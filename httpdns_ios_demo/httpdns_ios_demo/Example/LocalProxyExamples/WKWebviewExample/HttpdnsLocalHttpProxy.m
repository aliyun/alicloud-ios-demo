//
//  HttpdnsLocalHttpProxy.m
//  HTTPDNS iOS Local Proxy Solution
//
//  阿里云HTTPDNS本地代理服务实现
//  支持WKWebView通过本地HTTP代理进行网络请求，并集成HTTPDNS服务进行域名解析
//
//  功能特性：
//  - 自动启动本地HTTP代理服务
//  - 支持HTTP/HTTPS/Websocket协议代理
//  - 支持集成HTTPDNS解析器
//  - 运行时异常自动降级到系统网络
//  - iOS 17.0+ WKWebView代理配置支持
//
//  Created by Alibaba Cloud on 2025/06/28.
//

#import "HttpdnsLocalHttpProxy.h"
#import <Network/Network.h>
#import <os/log.h>
#import <netdb.h>

#pragma mark - 常量定义

/// 代理服务端口范围最小值
static const uint16_t kHTTPDNSProxyPortMin = 31000;

/// 代理服务端口范围最大值
static const uint16_t kHTTPDNSProxyPortMax = 32000;

/// 端口重试最大次数
static const NSInteger kHTTPDNSProxyMaxRetryAttempts = 3;

/// 代理启动超时时间（秒）
static const NSTimeInterval kHTTPDNSProxyStartupTimeout = 5.0;

/// 端口重试间隔时间（微秒）
static const useconds_t kHTTPDNSProxyRetryInterval = 100000; // 100ms

/// 统一日志子系统
static os_log_t _httpdnsProxyLogger;

/// 初始化日志系统
static void _initializeLogger(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _httpdnsProxyLogger = os_log_create("com.alicloud.httpdns", "LocalProxy");
    });
}

/// 便捷日志宏定义
#define HTTPDNS_LOCAL_PROXY_LOG_INFO(fmt, ...)    os_log_info(_httpdnsProxyLogger, fmt, ##__VA_ARGS__)
#define HTTPDNS_LOCAL_PROXY_LOG_ERROR(fmt, ...)   os_log_error(_httpdnsProxyLogger, fmt, ##__VA_ARGS__)
#define HTTPDNS_LOCAL_PROXY_LOG_DEBUG(fmt, ...)   os_log_debug(_httpdnsProxyLogger, fmt, ##__VA_ARGS__)

API_AVAILABLE(ios(17.0))
@interface HttpdnsLocalHttpProxy ()

#pragma mark - 私有属性

/// 代理服务运行状态（线程安全的原子操作属性）
@property (atomic, assign) BOOL isProxyRunning;

/// 当前代理服务监听端口
@property (nonatomic, readonly) uint16_t proxyPort;

/// 自定义DNS解析器回调块
@property (nonatomic, copy) NSString *(^customDNSResolverBlock)(NSString *hostname);

@end

API_AVAILABLE(ios(17.0))
@implementation HttpdnsLocalHttpProxy {
    /// 本地代理端口的监听器，负责接收客户端连接
    nw_listener_t _listener;

    /// 串行队列，用于同步start/stop操作，保证线程安全
    dispatch_queue_t _operationQueue;
}

#pragma mark - 初始化

+ (void)load {
    // 初始化日志系统
    _initializeLogger();

    // 仅在iOS 17+系统上自动启动代理服务
    if (@available(iOS 17.0, *)) {
        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("System version supports WKWebView proxy configuration, preparing to start proxy service");

        // 延迟启动，避免在类加载阶段阻塞主线程
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                      dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
            BOOL success = [[self sharedInstance] start];
            if (success) {
                HTTPDNS_LOCAL_PROXY_LOG_INFO("Proxy service auto-start successful");
            } else {
                HTTPDNS_LOCAL_PROXY_LOG_ERROR("Proxy service auto-start failed");
            }
        });
    } else {
        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("System version below iOS 17.0, skipping proxy service startup");
    }
}

#pragma mark - 单例模式

+ (instancetype)sharedInstance {
    static HttpdnsLocalHttpProxy *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HttpdnsLocalHttpProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 对象生命周期

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化实例变量
        _proxyPort = 0;                    // 端口将在启动时动态分配
        _isProxyRunning = NO;              // 初始状态为未运行
        _listener = NULL;                  // 监听器初始为空

        // 创建专用的串行队列用于同步start/stop操作
        _operationQueue = dispatch_queue_create("com.alicloud.httpdns.proxy.operation", DISPATCH_QUEUE_SERIAL);

        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Proxy service instance initialization completed");
    }
    return self;
}

- (void)dealloc {
    [self stop];
    HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Proxy service instance destroyed");
}

#pragma mark - 核心接口：WebView集成

- (BOOL)_installIntoWebViewConfiguration:(WKWebViewConfiguration *)configuration {
    // 参数有效性检查
    if (!configuration) {
        HTTPDNS_LOCAL_PROXY_LOG_ERROR("WebView configuration object is null, cannot install proxy");
        return NO;
    }

    // 系统版本兼容性检查
    if (@available(iOS 17.0, *)) {
        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("System version supports WebView proxy configuration");

        // 检查代理服务运行状态
        if (!self.isProxyRunning) {
            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Proxy service not running, enabling system network fallback mode");

            // 使用非持久化数据存储，确保清除任何旧的代理配置
            WKWebsiteDataStore *dataStore = [WKWebsiteDataStore nonPersistentDataStore];
            configuration.websiteDataStore = dataStore;

            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Configured WebView to use system network (no proxy mode)");
            return NO;
        }

        // 代理服务正常运行，配置WebView使用本地代理
        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Proxy service running normally, starting WebView proxy configuration");

        // 创建代理端点配置
        NSString *proxyHost = @"127.0.0.1";
        NSString *proxyPortString = [NSString stringWithFormat:@"%d", _proxyPort];
        nw_endpoint_t proxyEndpoint = nw_endpoint_create_host([proxyHost UTF8String], [proxyPortString UTF8String]);

        // 创建HTTP CONNECT代理配置
        nw_proxy_config_t proxyConfig = nw_proxy_config_create_http_connect(proxyEndpoint, NULL);
        if (proxyConfig) {
            WKWebsiteDataStore *dataStore = [WKWebsiteDataStore defaultDataStore];
            NSArray<nw_proxy_config_t> *proxyConfigs = @[proxyConfig];

            // 检查API可用性并设置代理配置
            if ([dataStore respondsToSelector:@selector(setProxyConfigurations:)]) {
                [dataStore setProxyConfigurations:proxyConfigs];
                configuration.websiteDataStore = dataStore;

                HTTPDNS_LOCAL_PROXY_LOG_INFO("WebView proxy configuration successful - listening address: %@:%d", proxyHost, _proxyPort);
                return YES;
            } else {
                HTTPDNS_LOCAL_PROXY_LOG_DEBUG("System doesn't support setProxyConfigurations API, enabling fallback mode");
            }
        } else {
            HTTPDNS_LOCAL_PROXY_LOG_ERROR("Cannot create proxy configuration object, enabling fallback mode");
        }

        // 配置失败时的降级处理
        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Proxy configuration failed, WebView will use system network");
        return NO;

    } else {
        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("System version below iOS 17.0, doesn't support WebView proxy configuration, using system network");
        return NO;
    }
}

#pragma mark - 服务控制

/**
 *  自动选择可用端口并启动本地HTTP代理服务
 *  支持端口冲突重试机制，最多尝试3个随机端口
 */
- (BOOL)start {
    __block BOOL result = NO;

    dispatch_sync(_operationQueue, ^{
        // 检查服务是否已经在运行
        if (self.isProxyRunning) {
            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Proxy service already running - listening address: 127.0.0.1:%d", _proxyPort);
            result = YES;
            return;
        }

        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Starting proxy service");

        // 端口重试机制：最多尝试指定次数的随机端口
        for (NSInteger attempt = 0; attempt < kHTTPDNSProxyMaxRetryAttempts; attempt++) {
            uint16_t port = [self generateRandomPort];

            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Attempt %ld/%ld to start - port: 127.0.0.1:%d",
                            (long)(attempt + 1), (long)kHTTPDNSProxyMaxRetryAttempts, port);

            // 配置网络连接参数
            nw_parameters_t parameters = nw_parameters_create_secure_tcp(
                NW_PARAMETERS_DISABLE_PROTOCOL,    // 禁用TLS，代理本身不加密
                NW_PARAMETERS_DEFAULT_CONFIGURATION
            );

            // 启用地址重用，便于快速重启和端口复用
            nw_parameters_set_reuse_local_address(parameters, true);

            // 创建本地回环地址端点，仅监听本地连接
            NSString *portString = [NSString stringWithFormat:@"%d", port];
            nw_endpoint_t localEndpoint = nw_endpoint_create_host("127.0.0.1", [portString UTF8String]);
            nw_parameters_set_local_endpoint(parameters, localEndpoint);

            // 使用配置创建网络监听器
            _listener = nw_listener_create(parameters);

            if (!_listener) {
                HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Port %d listener creation failed", port);

                if (attempt < kHTTPDNSProxyMaxRetryAttempts - 1) {
                    usleep(kHTTPDNSProxyRetryInterval);
                }
                continue;
            }

            // 监听器状态变化处理：区分启动阶段和运行时阶段
            __block BOOL startSuccess = NO;
            __block BOOL startCompleted = NO;
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

            nw_listener_set_state_changed_handler(_listener, ^(nw_listener_state_t state, nw_error_t error) {
                if (!startCompleted) {
                    // 启动阶段：等待监听器就绪或失败
                    switch (state) {
                        case nw_listener_state_ready:
                            self->_isProxyRunning = YES;
                            startSuccess = YES;
                            startCompleted = YES;
                            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Port %d listener started successfully", port);
                            dispatch_semaphore_signal(semaphore);
                            break;

                        case nw_listener_state_failed:
                        case nw_listener_state_cancelled:
                            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Port %d listener startup failed - state: %d", port, state);
                            startSuccess = NO;
                            startCompleted = YES;
                            dispatch_semaphore_signal(semaphore);
                            break;

                        default:
                            // 其他状态不处理，继续等待
                            break;
                    }
                } else {
                    // 运行时阶段：监控异常情况
                    switch (state) {
                        case nw_listener_state_failed:
                            HTTPDNS_LOCAL_PROXY_LOG_ERROR("Proxy service runtime exception - listener failed");
                            self->_isProxyRunning = NO;

                            // 记录详细错误信息
                            if (error) {
                                nw_error_domain_t domain = nw_error_get_error_domain(error);
                                int code = nw_error_get_error_code(error);
                                HTTPDNS_LOCAL_PROXY_LOG_ERROR("Error details - domain: %d, code: %d", domain, code);
                            }

                            break;

                        case nw_listener_state_cancelled:
                            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Proxy service listener cancelled");
                            self->_isProxyRunning = NO;

                            break;

                        default:
                            break;
                    }
                }
            });

            // 设置新连接处理器
            nw_listener_set_new_connection_handler(_listener, ^(nw_connection_t connection) {
                // 在工具队列中处理连接，避免阻塞主队列
                nw_connection_set_queue(connection, dispatch_get_global_queue(QOS_CLASS_UTILITY, 0));
                nw_connection_start(connection);
                [self handleConnection:connection];
            });

            // 设置监听器队列并启动
            nw_listener_set_queue(_listener, dispatch_get_main_queue());
            nw_listener_start(_listener);

            // 等待启动完成（超时保护）
            dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kHTTPDNSProxyStartupTimeout * NSEC_PER_SEC));
            long semaphoreResult = dispatch_semaphore_wait(semaphore, timeout);

            if (semaphoreResult != 0) {
                // 启动超时处理
                HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Port %d startup timeout (%.1f seconds)", port, kHTTPDNSProxyStartupTimeout);
                [self cleanup];

                if (attempt < kHTTPDNSProxyMaxRetryAttempts - 1) {
                    usleep(kHTTPDNSProxyRetryInterval);
                }
                continue;
            }

            // 检查启动结果
            if (startSuccess) {
                _proxyPort = port;
                HTTPDNS_LOCAL_PROXY_LOG_INFO("Proxy service started successfully - listening address: 127.0.0.1:%d", _proxyPort);
                result = YES;
                return;
            } else {
                // 启动失败，清理资源
                [self cleanup];

                if (attempt < kHTTPDNSProxyMaxRetryAttempts - 1) {
                    usleep(kHTTPDNSProxyRetryInterval);
                }
            }
        }

        // 所有端口尝试失败
        HTTPDNS_LOCAL_PROXY_LOG_ERROR("Proxy service startup failed - tried %ld ports", (long)kHTTPDNSProxyMaxRetryAttempts);
        result = NO;
    });

    return result;
}

/**
 *  安全关闭代理服务，释放所有网络资源
 *  包括监听器、活跃连接等
 */
- (void)stop {
    dispatch_sync(_operationQueue, ^{
        // 检查服务状态（双重检查锁定模式）
        if (!self.isProxyRunning) {
            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Proxy service not running, no need to stop");
            return;
        }

        HTTPDNS_LOCAL_PROXY_LOG_INFO("Stopping proxy service...");

        // 标记服务为停止状态，防止新的连接建立
        self->_isProxyRunning = NO;

        // 清理活跃连接
        [self cleanup];

        HTTPDNS_LOCAL_PROXY_LOG_INFO("Proxy service stopped successfully");
    });
}

/**
 *  释放监听器、取消活跃连接、重置端口状态
 *  确保资源完全释放，避免内存泄漏
 */
- (void)cleanup {
    // 清理监听器
    if (_listener) {
        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Cancelling network listener");
        nw_listener_cancel(_listener);
        _listener = NULL;
    }

    // Network Framework会自动管理连接生命周期
    // 现有连接会在以下情况自动清理：
    // 1. 客户端断开连接（如WebView销毁）
    // 2. 网络请求完成
    // 3. 连接超时或出错

    // 重置端口状态
    _proxyPort = 0;
}

#pragma mark - 连接处理

/**
 *  接收来自WebView的新的连接请求，进行协议解析和转发
 *  支持HTTP和HTTPS CONNECT协议
 *
 *  @param connection 客户端网络连接对象
 */
- (void)handleConnection:(nw_connection_t)connection {
    HTTPDNS_LOCAL_PROXY_LOG_DEBUG("New client connection established");

    // 设置连接状态监控
    nw_connection_set_state_changed_handler(connection, ^(nw_connection_state_t state, nw_error_t error) {
        switch (state) {
            case nw_connection_state_failed:
            case nw_connection_state_cancelled: {
                // 记录连接失败的详细信息
                if (state == nw_connection_state_failed && error) {
                    nw_error_domain_t domain = nw_error_get_error_domain(error);
                    int code = nw_error_get_error_code(error);
                    HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Client connection failed - error domain: %d, error code: %d", domain, code);

                    // 检查是否为系统级严重错误
                    if (domain == nw_error_domain_posix && (code == EADDRINUSE || code == EACCES)) {
                        HTTPDNS_LOCAL_PROXY_LOG_ERROR("Detected system-level network error, proxy service may need restart");
                    }
                } else if (state == nw_connection_state_cancelled) {
                    HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Client connection disconnected normally");
                }
                break;
            }

            case nw_connection_state_ready:
                HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Client connection ready");
                break;

            default:
                break;
        }
    });

    // 接收客户端HTTP请求数据
    nw_connection_receive(connection, 1, 4096, ^(dispatch_data_t content, nw_content_context_t context, bool is_complete, nw_error_t error) {
        // 错误处理
        if (error) {
            nw_error_domain_t domain = nw_error_get_error_domain(error);
            int code = nw_error_get_error_code(error);

            if (domain == nw_error_domain_posix && code == 54) {
                HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Client actively disconnected");
            } else {
                HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Receive data error - error domain: %d, error code: %d", domain, code);
            }

            nw_connection_cancel(connection);
            return;
        }

        // 数据有效性检查
        if (!content || dispatch_data_get_size(content) == 0) {
            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Received empty data packet");
            if (is_complete) {
                nw_connection_cancel(connection);
            }
            return;
        }

        // 解析HTTP请求
        NSData *data = [self dataFromDispatchData:content];
        NSString *requestLine = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        // 检查请求是否有效
        if (!requestLine || requestLine.length == 0) {
            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("HTTP request data invalid or cannot be parsed");
            nw_connection_cancel(connection);
            return;
        }

        NSArray *lines = [requestLine componentsSeparatedByString:@"\r\n"];
        if (lines.count == 0) {
            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("HTTP request format invalid: missing request line");
            nw_connection_cancel(connection);
            return;
        }

        NSString *firstLine = lines[0];
        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Received HTTP request: %@", firstLine);

        // 只创建了CONNECT的代理配置，webkit只会通过CONNECT请求发起建连
        if ([requestLine hasPrefix:@"CONNECT "]) {
            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Processing HTTPS CONNECT tunnel request");
            [self handleHTTPSConnect:data fromConnection:connection];
        } else {
            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Unknown request type: %@", firstLine);
            nw_connection_cancel(connection);
        }
    });
}

#pragma mark - HTTPS隧道处理

- (void)handleHTTPSConnect:(NSData *)data fromConnection:(nw_connection_t)clientConnection {
    NSString *line = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    // 解析CONNECT请求格式：CONNECT host:port HTTP/1.1
    NSScanner *scanner = [NSScanner scannerWithString:line];
    NSString *method, *hostport;
    [scanner scanUpToString:@" " intoString:&method];
    [scanner scanString:@" " intoString:nil];
    [scanner scanUpToString:@" " intoString:&hostport];

    NSArray *parts = [hostport componentsSeparatedByString:@":"];
    if (parts.count != 2) {
        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("CONNECT request format invalid: %@", hostport);
        nw_connection_cancel(clientConnection);
        return;
    }

    NSString *host = parts[0];
    uint16_t port = (uint16_t)[parts[1] intValue];

    HTTPDNS_LOCAL_PROXY_LOG_DEBUG("🔗 CONNECT host: %@:%d, client: %p", host, port, clientConnection);

    // 解析域名并创建到目标服务器的连接
    NSString *resolvedHost = [self resolveHostname:host];
    nw_connection_t remoteConnection = [self createConnectionToHost:resolvedHost port:port];

    HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Establishing HTTPS tunnel connection: %@:%d (resolved: %@)", host, port, resolvedHost);

    // 配置远程连接处理队列
    nw_connection_set_queue(remoteConnection, dispatch_get_global_queue(QOS_CLASS_UTILITY, 0));

    // 设置HTTPS隧道连接状态监控
    nw_connection_set_state_changed_handler(remoteConnection, ^(nw_connection_state_t state, nw_error_t error) {
        switch (state) {
            case nw_connection_state_ready: {
                HTTPDNS_LOCAL_PROXY_LOG_DEBUG("HTTPS tunnel connection established successfully: %@:%d", host, port);

                // 发送HTTP 200响应，表示隧道建立成功
                const char *resp = "HTTP/1.1 200 Connection Established\r\n\r\n";
                NSData *respData = [NSData dataWithBytes:resp length:strlen(resp)];
                nw_connection_send(clientConnection, [self dispatchDataFromNSData:respData],
                                 NW_CONNECTION_DEFAULT_MESSAGE_CONTEXT, false, ^(nw_error_t err) {
                    if (!err) {
                        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Starting HTTPS tunnel bidirectional data relay");
                        // 启动双向透明数据转发
                        [self relayFrom:clientConnection to:remoteConnection];
                        [self relayFrom:remoteConnection to:clientConnection];
                    } else {
                        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Failed to send HTTPS tunnel confirmation response");
                        nw_connection_cancel(remoteConnection);
                        nw_connection_cancel(clientConnection);
                    }
                });
                break;
            }

            case nw_connection_state_failed: {
                HTTPDNS_LOCAL_PROXY_LOG_DEBUG("HTTPS tunnel connection failed: %@:%d", host, port);
                [self sendBadGatewayResponse:clientConnection];
                break;
            }

            case nw_connection_state_cancelled:
                HTTPDNS_LOCAL_PROXY_LOG_DEBUG("HTTPS tunnel connection cancelled: %@:%d", host, port);
                nw_connection_cancel(clientConnection);
                break;

            default:
                break;
        }
    });

    // 启动HTTPS隧道连接
    nw_connection_start(remoteConnection);
}

#pragma mark - 数据转发

- (void)relayFrom:(nw_connection_t)source to:(nw_connection_t)destination {
    // 接收数据并转发到目标连接
    nw_connection_receive(source, 1, 8192, ^(dispatch_data_t content, nw_content_context_t context, bool is_complete, nw_error_t error) {
        // 处理接收错误
        if (error) {
            nw_error_domain_t domain = nw_error_get_error_domain(error);
            int code = nw_error_get_error_code(error);

            if (domain == nw_error_domain_posix && code == 54) {
                HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Peer connection closed");
            } else {
                HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Data relay receive error - error domain: %d, error code: %d", domain, code);
            }

            // 发生错误时关闭双向连接
            nw_connection_cancel(source);
            nw_connection_cancel(destination);
            return;
        }

        // 转发有效数据
        if (content && dispatch_data_get_size(content) > 0) {
            size_t dataSize = dispatch_data_get_size(content);

            // 监控大数据包传输（用于性能分析）
            if (dataSize > 4096) {
                HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Forwarding large data packet: %zu bytes", dataSize);
            }

            // 发送数据到目标连接
            nw_connection_send(destination, content, NW_CONNECTION_DEFAULT_MESSAGE_CONTEXT, false, ^(nw_error_t sendError) {
                if (sendError) {
                    HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Data relay send failed");
                    nw_connection_cancel(source);
                    nw_connection_cancel(destination);
                    return;
                }
            });
        }

        // 处理流结束
        if (is_complete) {
            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Data stream transmission completed");
            nw_connection_cancel(destination);
        } else {
            // 使用异步调度避免递归调用导致的栈溢出
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
                [self relayFrom:source to:destination];
            });
        }
    });
}

#pragma mark - 数据转换工具

- (NSData *)dataFromDispatchData:(dispatch_data_t)data {
    __block NSMutableData *result = [NSMutableData data];
    dispatch_data_apply(data, ^bool(dispatch_data_t region, size_t offset, const void *buffer, size_t size) {
        [result appendBytes:buffer length:size];
        return true;
    });
    return result;
}

- (dispatch_data_t)dispatchDataFromNSData:(NSData *)data {
    return dispatch_data_create([data bytes], [data length], NULL, DISPATCH_DATA_DESTRUCTOR_DEFAULT);
}

#pragma mark - 辅助方法

/**
 *  在预定义范围内生成范围在[31000, 32000)随机端口，用于避免端口冲突
 */
- (uint16_t)generateRandomPort {
    // 在指定范围内生成随机端口号，避免端口冲突
    uint32_t range = kHTTPDNSProxyPortMax - kHTTPDNSProxyPortMin;
    uint16_t randomPort = kHTTPDNSProxyPortMin + arc4random_uniform(range);
    return randomPort;
}

/**
 *  使用配置的DNS解析器（例如HTTPDNS）解析域名
 *  如果解析失败，返回原始域名使用系统DNS解析
 *
 *  @return 解析后的IP地址或原始域名
 */
- (NSString *)resolveHostname:(NSString *)hostname {
    // 参数有效性检查
    if (!hostname || hostname.length == 0 || [hostname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Domain parameter invalid, returning original value: %@", hostname ?: @"(null)");
        return hostname ?: @"";
    }

    NSString *resolvedHost = hostname;

    // 使用自定义DNS解析器
    if (self.customDNSResolverBlock) {
        @try {
            NSString *resolvedIP = self.customDNSResolverBlock(hostname);
            if (resolvedIP && ![resolvedIP isEqualToString:hostname]) {
                resolvedHost = resolvedIP;
                HTTPDNS_LOCAL_PROXY_LOG_DEBUG("DNS resolution successful: %@ -> %@", hostname, resolvedHost);
            } else {
                HTTPDNS_LOCAL_PROXY_LOG_DEBUG("DNS resolution unchanged: %@", hostname);
            }
        } @catch (NSException *exception) {
            HTTPDNS_LOCAL_PROXY_LOG_ERROR("DNS resolver exception: %@, using original domain", exception.reason ?: @"Unknown error");
        }
    } else {
        HTTPDNS_LOCAL_PROXY_LOG_DEBUG("No custom DNS resolver configured, using system DNS");
    }

    return resolvedHost;
}

/**
 *  当目标服务器连接失败时，向客户端返回502错误响应
 */
- (void)sendBadGatewayResponse:(nw_connection_t)connection {
    // 发送标准502错误响应
    const char *errorResp = "HTTP/1.1 502 Bad Gateway\r\n"
                           "Content-Length: 0\r\n"
                           "Connection: close\r\n\r\n";

    NSData *errorData = [NSData dataWithBytes:errorResp length:strlen(errorResp)];

    nw_connection_send(connection, [self dispatchDataFromNSData:errorData],
                      NW_CONNECTION_DEFAULT_MESSAGE_CONTEXT, true, ^(nw_error_t err) {
        if (err) {
            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Failed to send 502 error response");
        } else {
            HTTPDNS_LOCAL_PROXY_LOG_DEBUG("Sent 502 error response");
        }
        nw_connection_cancel(connection);
    });
}

/**
 *  创建本地代理到目标服务器的连接
 */
- (nw_connection_t)createConnectionToHost:(NSString *)host port:(uint16_t)port {
    // 创建远程端点（host现在应该已经是解析后的IP地址或原始域名）
    NSString *portString = [NSString stringWithFormat:@"%d", port];
    nw_endpoint_t remoteEndpoint = nw_endpoint_create_host([host UTF8String], [portString UTF8String]);

    // 创建禁用TLS的TCP连接参数（代理本身不加密）
    nw_parameters_t params = nw_parameters_create_secure_tcp(
        NW_PARAMETERS_DISABLE_PROTOCOL,
        NW_PARAMETERS_DEFAULT_CONFIGURATION
    );

    // 启用地址重用，便于端口快速重绑定
    nw_parameters_set_reuse_local_address(params, true);

    nw_connection_t connection = nw_connection_create(remoteEndpoint, params);

    // 设置连接队列
    nw_connection_set_queue(connection, dispatch_get_global_queue(QOS_CLASS_UTILITY, 0));

    return connection;
}

#pragma mark - 静态API实现

+ (void)setDNSResolverBlock:(NSString *(^)(NSString *hostname))resolverBlock {
    HttpdnsLocalHttpProxy *proxy = [HttpdnsLocalHttpProxy sharedInstance];
    proxy.customDNSResolverBlock = [resolverBlock copy];

    if (resolverBlock) {
        HTTPDNS_LOCAL_PROXY_LOG_INFO("Custom DNS resolver installed");
    } else {
        HTTPDNS_LOCAL_PROXY_LOG_INFO("Custom DNS resolver removed, will use system DNS");
    }
}

+ (BOOL)installIntoWebViewConfiguration:(WKWebViewConfiguration *)configuration {
    HttpdnsLocalHttpProxy *proxy = [HttpdnsLocalHttpProxy sharedInstance];
    return [proxy _installIntoWebViewConfiguration:configuration];
}

@end
