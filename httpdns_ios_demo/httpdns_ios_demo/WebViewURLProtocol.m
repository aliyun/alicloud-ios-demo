//
//  WebViewURLProtocol.m
//  httpdns_ios_demo
//
//  Created by fuyuan.lfy on 16/6/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WebViewURLProtocol.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import <objc/runtime.h>
#import <arpa/inet.h>

#define protocolKey @"CFHttpMessagePropertyKey"
#define kAnchorAlreadyAdded @"AnchorAlreadyAdded"

@interface WebViewURLProtocol () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation WebViewURLProtocol
/**
 *  是否拦截处理指定的请求
 *
 *  @param request 指定的请求
 *
 *  @return 返回YES表示要拦截处理，返回NO表示不拦截处理
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    /* 防止无限循环，因为一个请求在被拦截处理过程中，也会发起一个请求，这样又会走到这里，如果不进行处理，就会造成无限循环 */
    if ([NSURLProtocol propertyForKey:protocolKey inRequest:request]) {
        return NO;
    }
    
    /*
     *  降级处理逻辑：
     *  1. 不拦截基于IP访问的请求；
     *  2. HTTPDNS无法返回对应Host的解析结果IP时，不拦截处理该请求，交由其他注册Protocol或系统原生网络库处理。
     *  基于此，可通过控制台下线域名，动态控制客户端降级。
     *  ***************************************************************************
     *  【注意】当HTTPDNS不可用时，一定要做好降级处理，减少网络请求处理的无意义干涉，降低风险。
     *  添加该降级逻辑时，一定要基于HTTPDNS最新版本SDK构建。
     *  HTTPDNS iOS SDK包括:
     *      AlicloudHttpDNS.framework
     *      AlicloudUtils.framework
     *      UTDID.framework
     *  各Framework都要升级到线上最新版本，否则不能使用该降级处理逻辑，切记！
     *  ***************************************************************************
     */
    if (![self canHTTPDNSResolveHost:request.URL.host]) {
        NSLog(@"HTTPDNS can't resolve [%@] now.", request.URL.host);
        return NO;
    }
    
    NSMutableURLRequest *mutableReq = [request mutableCopy];
    
    // 假设原始的请求头部没有host信息，只有使用IP替换后的请求才有
    NSString *host = [mutableReq valueForHTTPHeaderField:@"host"];
    
    // 假设只拦截原始请求中css的请求
    if (mutableReq && !host && [[mutableReq.HTTPMethod lowercaseString] isEqualToString:@"get"] && [mutableReq.URL.absoluteString hasSuffix:@".css"]) {
        return YES;
    }
    return NO;
}

/**
 *  如果需要对请求进行重定向，添加指定头部等操作，可以在该方法中进行
 *
 *  @param request 原请求
 *
 *  @return 修改后的请求
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReq = [request mutableCopy];
    NSString *originalUrl = mutableReq.URL.absoluteString;
    NSURL *url = [NSURL URLWithString:originalUrl];
    // 异步接口获取IP地址
    NSString *ip = [[HttpDnsService sharedInstance] getIpByHostAsync:url.host];
    if (ip) {
        // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
        NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", ip, url.host);
        NSRange hostFirstRange = [originalUrl rangeOfString:url.host];
        if (NSNotFound != hostFirstRange.location) {
            NSString *newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
            NSLog(@"New URL: %@", newUrl);
            mutableReq.URL = [NSURL URLWithString:newUrl];
            [mutableReq setValue:url.host forHTTPHeaderField:@"host"];
            // 添加originalUrl保存原始URL
            [mutableReq addValue:originalUrl forHTTPHeaderField:@"originalUrl"];
        }
    }
    return [mutableReq copy];
}
/**
 *  开始加载，在该方法中，加载一个请求
 */
- (void)startLoading {
    NSMutableURLRequest *request = [self.request mutableCopy];
    // 表示该请求已经被处理，防止无限循环
    [NSURLProtocol setProperty:@(YES) forKey:protocolKey inRequest:request];
    [self startRequest];
}
/**
 *  取消请求
 */
- (void)stopLoading {
    [self.session invalidateAndCancel];
    self.session = nil;
}

/**
 *  检测当前HTTPDNS是否可以返回对应host解析结果
 *  host为空或host为IP地址，直接返回NO。
 */
+ (BOOL)canHTTPDNSResolveHost:(NSString *)host {
    if (!host || [self isIPAddress:host]) {
        return NO;
    }
    NSString *ip = [[HttpDnsService sharedInstance] getIpByHostAsync:host];
    return (ip != nil);
}

/**
 *  判断输入是否为IP地址
 */
+ (BOOL)isIPAddress:(NSString *)str {
    if (!str) {
        return NO;
    }
    int success;
    struct in_addr dst;
    struct in6_addr dst6;
    const char *utf8 = [str UTF8String];
    // check IPv4 address
    success = inet_pton(AF_INET, utf8, &(dst.s_addr));
    if (!success) {
        // check IPv6 address
        success = inet_pton(AF_INET6, utf8, &dst6);
    }
    return success;
}


/**
 *  使用NSURLSession转发请求
 */
- (void)startRequest {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    NSURLSessionTask *task = [_session dataTaskWithRequest:self.request];
    [task resume];
}

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain {
    /*
     * 创建证书校验策略
     */
    NSMutableArray *policies = [NSMutableArray array];
    if (domain) {
        [policies addObject:(__bridge_transfer id) SecPolicyCreateSSL(true, (__bridge CFStringRef) domain)];
    } else {
        [policies addObject:(__bridge_transfer id) SecPolicyCreateBasicX509()];
    }
    /*
     * 绑定校验策略到服务端的证书上
     */
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef) policies);
    /*
     * 评估当前serverTrust是否可信任，
     * 官方建议在result = kSecTrustResultUnspecified 或 kSecTrustResultProceed
     * 的情况下serverTrust可以被验证通过，https://developer.apple.com/library/ios/technotes/tn2232/_index.html
     * 关于SecTrustResultType的详细信息请参考SecTrust.h
     */
    SecTrustResultType result;
    SecTrustEvaluate(serverTrust, &result);
    return (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
}

#pragma NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler {
    if (!challenge) {
        return;
    }
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    /*
     * 获取原始域名信息。
     */
    NSString *host = [[self.request allHTTPHeaderFields] objectForKey:@"host"];
    if (!host) {
        host = self.request.URL.host;
    }
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([self evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:host]) {
            disposition = NSURLSessionAuthChallengeUseCredential;
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    // 对于其他的challenges直接使用默认的验证方案
    completionHandler(disposition, credential);
}

#pragma NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"receive response: %@", response);
    // 获取原始URL
    NSString* originalUrl = [dataTask.currentRequest valueForHTTPHeaderField:@"originalUrl"];
    if (!originalUrl) {
        originalUrl = response.URL.absoluteString;
    }
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSURLResponse *retResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:originalUrl] statusCode:httpResponse.statusCode HTTPVersion:(__bridge NSString *)kCFHTTPVersion1_1 headerFields:httpResponse.allHeaderFields];
        [self.client URLProtocol:self didReceiveResponse:retResponse cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    } else {
        NSURLResponse *retResponse = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:originalUrl] MIMEType:response.MIMEType expectedContentLength:response.expectedContentLength textEncodingName:response.textEncodingName];
        [self.client URLProtocol:self didReceiveResponse:retResponse cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    }
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

@end
