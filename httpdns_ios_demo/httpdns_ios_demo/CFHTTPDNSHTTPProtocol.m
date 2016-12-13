//
//  CFHTTPDNSHTTPProtocol.m
//  CFHTTPDNSRequest
//
//  Created by junmo on 16/12/8.
//  Copyright © 2016年 junmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <arpa/inet.h>
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "CFHTTPDNSHTTPProtocol.h"
#import "CFHTTPDNSRequestTaskDelegate.h"

/**
 *  本示例拦截HTTPS请求，使用HTTPDNS进行域名解析，基于CFNetwork发送HTTPS请求，并适配SNI配置；
 *  若有HTTP请求，或重定向时有HTTP请求，需要另注册其他NSURLProtocol来处理或者走系统原生处理逻辑。
 *
 *  NSURLProtocol API描述参考：https://developer.apple.com/reference/foundation/nsurlprotocol
 *  尽可能拦截少量网络请求，尽量避免直接基于CFNetwork发送HTTP/HTTPS请求。
 */

static NSString *recursiveRequestFlagProperty = @"com.aliyun.httpdns";

@interface CFHTTPDNSHTTPProtocol () <CFHTTPDNSRequestTaskDelegate>

// 基于CFNetwork发送HTTPS请求的Task
@property (atomic, strong) CFHTTPDNSRequestTask *task;
// 记录请求开始时间
@property (atomic, assign) NSTimeInterval startTime;

@end

@implementation CFHTTPDNSHTTPProtocol

#pragma mark NSURLProtocl API

/**
 *  是否拦截处理指定的请求
 *
 *  @param request 指定的请求
 *
 *  @return YES:拦截处理，NO:不拦截处理
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSLog(@"Rry to handle request: %@.", request);
    BOOL shouldAccept = YES;
    
    if (request == nil || request.URL == nil || request.URL.scheme == nil ||
        ![request.URL.scheme isEqualToString:@"https"] ||
        [NSURLProtocol propertyForKey:recursiveRequestFlagProperty inRequest:request] != nil) {
        shouldAccept = NO;
    }
    
    if (shouldAccept) {
        NSLog(@"Accept request: %@.", request);
    } else {
        NSLog(@"Decline request: %@.", request);
    }
    
    return shouldAccept;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

/**
 *  开始加载请求
 */
- (void)startLoading {
    NSMutableURLRequest *recursiveRequest = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:recursiveRequestFlagProperty inRequest:recursiveRequest];
    self.startTime = [NSDate timeIntervalSinceReferenceDate];
    // 构造CFHTTPDNSRequestTask，基于CFNetwork发送HTTPS请求
    NSURLRequest *swizzleRequest = [self httpdnsResolve:recursiveRequest];
    NSLog(@"SwizzleRequest: %@", swizzleRequest);
    self.task = [[CFHTTPDNSRequestTask alloc] initWithURLRequest:recursiveRequest swizzleRequest:swizzleRequest delegate:self];
    if (self.task) {
        [self.task startLoading];
    }
}

/**
 *  停止加载请求
 */
- (void)stopLoading {
    NSLog(@"Stop loading, elapsed %.1f seconds.", [NSDate timeIntervalSinceReferenceDate] - self.startTime);
    if (self.task) {
        [self.task stopLoading];
        self.task = nil;
    }
}

#pragma mark CFHTTPDNSRequestTask Protocol

- (void)task:(CFHTTPDNSRequestTask *)task didReceiveRedirection:(NSURLRequest *)request response:(NSURLResponse *)response {
    NSLog(@"Redirect from [%@] to [%@].", response.URL, request.URL);
    NSMutableURLRequest *mRequest = [request mutableCopy];
    [NSURLProtocol removePropertyForKey:recursiveRequestFlagProperty inRequest:mRequest];
    NSURLResponse *cResponse = [response copy];
    [task stopLoading];
    /*
     *  交由NSProtocolClient处理重定向请求
     *  request: 重定向后的request
     *  redirectResponse: 原请求返回的Response
     */
    [self.client URLProtocol:self wasRedirectedToRequest:mRequest redirectResponse:cResponse];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)task:(CFHTTPDNSRequestTask *)task didReceiveResponse:(NSURLResponse *)response cachePolicy:(NSURLCacheStoragePolicy)cachePolicy {
    NSLog(@"Did receive response: %@", response);
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:cachePolicy];
}

- (void)task:(CFHTTPDNSRequestTask *)task didReceiveData:(NSData *)data {
    NSLog(@"Did receive data.");
    [self.client URLProtocol:self didLoadData:data];
}

- (void)task:(CFHTTPDNSRequestTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"Did complete with error, %@.", error);
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        NSLog(@"Did complete success.");
        [self.client URLProtocolDidFinishLoading:self];
    }
}

/**
 *  HTTPDNS解析域名，重新构造请求
 *  若原始请求基于IP地址，无需做域名解析直接返回
 */
- (NSURLRequest *)httpdnsResolve:(NSURLRequest *)request {
    NSMutableURLRequest *swizzleRequest;
    NSLog(@"HTTPDNS start resolve URL: %@", request.URL.absoluteString);
    NSURL *originURL = request.URL;
    // 原始请求基于IP访问
    if ([self isIPAddress:originURL.host]) {
        NSLog(@"[%@] is IP based URL, return.", originURL.absoluteString);
        return request;
    }
    NSString *originURLStr = originURL.absoluteString;
    swizzleRequest = [request mutableCopy];
    NSString *ip = [[HttpDnsService sharedInstance] getIpByHostAsync:originURL.host];
    // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
    if (ip) {
        NSLog(@"Get IP from HTTPDNS Successfully!");
        NSRange hostFirstRange = [originURLStr rangeOfString:originURL.host];
        if (NSNotFound != hostFirstRange.location) {
            NSString *newUrl = [originURLStr stringByReplacingCharactersInRange:hostFirstRange withString:ip];
            swizzleRequest.URL = [NSURL URLWithString:newUrl];
            [swizzleRequest setValue:originURL.host forHTTPHeaderField:@"host"];
        }
    } else {
        // 没有获取到域名解析结果
        return request;
    }
    return swizzleRequest;
}

/**
 *  判断输入是否为IP地址
 */
- (BOOL)isIPAddress:(NSString *)str {
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

@end
