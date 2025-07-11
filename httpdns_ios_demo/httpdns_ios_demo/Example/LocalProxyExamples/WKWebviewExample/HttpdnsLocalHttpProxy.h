//
//  HttpdnsLocalHttpProxy.h
//  HTTPDNS iOS Local Proxy Solution
//
//  阿里云HTTPDNS本地代理服务接口定义
//  提供WKWebView透明代理支持，集成HTTPDNS域名解析服务
//
//  主要功能：
//  • 自动启动本地HTTP代理服务
//  • 支持HTTP/HTTPS协议代理
//  • 无缝集成阿里云HTTPDNS服务
//  • iOS 17.0+ WKWebView代理配置支持
//
//  Created by Alibaba Cloud on 2025/06/28.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  阿里云HTTPDNS本地代理服务
 *
 *  静态工具类，提供简洁的API接口用于WebView代理配置
 *  结合HTTPDNS实现域名解析加速和网络访问优化
 *
 *  核心特性：
 *  - 静态API设计：无需管理实例，直接调用类方法
 *  - 自动生命周期管理：类加载时自动启动代理服务
 *  - 高性能转发：基于Network framework的异步I/O
 *  - 安全隔离：仅监听本地回环地址，避免安全风险
 *
 *  使用场景：
 *  - WKWebView网络请求代理
 *  - HTTPDNS域名解析集成
 *  - 网络访问监控和优化
 *
 *  @since iOS 10.0
 *  @warning 代理配置功能需要iOS 17.0+
 */
@interface HttpdnsLocalHttpProxy : NSObject

#pragma mark - DNS解析配置

/**
 *  设置自定义DNS解析器
 *
 *  通过此方法可注入自定义DNS解析逻辑，实现与具体DNS服务的解耦
 *  支持使用阿里云HTTPDNS
 *
 *  @param resolverBlock DNS解析器回调块
 *         - 参数：NSString *hostname - 待解析的域名
 *         - 返回：NSString * - 解析后的IP地址，解析失败时返回nil或原域名
 *         - 注意：回调可能在任意线程执行，需要保证线程安全
 *
 *  @code
 *  // 示例：集成阿里云HTTPDNS
 *  [HttpdnsLocalHttpProxy setDNSResolverBlock:^NSString *(NSString *hostname) {
 *      return [[HttpDnsService sharedInstance] getIpByHostSync:hostname];
 *  }];
 *  @endcode
 */
+ (void)setDNSResolverBlock:(NSString * _Nullable (^)(NSString *hostname))resolverBlock;

#pragma mark - WebView集成

/**
 *  配置WKWebViewConfiguration使用本地代理
 *
 *  这是主要的集成接口，一步完成WebView代理配置
 *  代理服务已在类加载时自动启动，此方法专注于WebView配置
 *
 *  执行流程：
 *  1. 系统版本检查：iOS 17.0+支持代理配置
 *  2. 检查代理服务状态
 *  3. 创建本地代理端点配置
 *  4. 应用代理配置到WebView数据存储
 *
 *  @param configuration 目标WKWebViewConfiguration实例，不能为nil
 *  @return YES表示代理配置成功，NO表示使用系统网络
 *
 *  @code
 *  // 简单使用示例
 *  WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
 *  BOOL success = [HttpdnsLocalHttpProxy installIntoWebViewConfiguration:config];
 *  WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:config];
 *  @endcode
 */
+ (BOOL)installIntoWebViewConfiguration:(WKWebViewConfiguration *)configuration;

@end

NS_ASSUME_NONNULL_END
