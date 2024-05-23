//
//  HTTPSScene.m
//  httpdns_ios_demo
//
//  Created by chenyilong on 12/9/2017.
//  Copyright © 2017 alibaba. All rights reserved.
//

#import "HTTPSScene.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

@interface HTTPSScene () <NSURLConnectionDelegate, NSURLSessionTaskDelegate, NSURLConnectionDataDelegate, NSURLSessionDataDelegate>
@property (nonatomic, strong) NSMutableURLRequest *request;
@end

@implementation HTTPSScene

- (void)beginQuery:(NSString *)originalUrl {
    // 初始化httpdns实例
    HttpDnsService *httpdns = [HttpDnsService sharedInstance];
    
//    NSString *originalUrl = @"https://www.apple.com";
    NSURL *url = [NSURL URLWithString:originalUrl];
    self.request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    HttpdnsResult *result = [httpdns resolveHostSyncNonBlocking:url.host byIpType:HttpdnsQueryIPTypeBoth];
    if (result) {
        if (result.hasIpv4Address) {
            //使用ip
            NSString *ip = result.firstIpv4Address;
            [self replaceRequestForIP:ip fromUrl:url withOriginalUrl:originalUrl];
            
            //使用ip列表
            NSArray<NSString *> *ips = result.ips;
            //根据业务场景进行ip使用
            /*
             * NSString *ip = result.ips.firstObject;
             * request = [self replaceRequestForIP:ip fromUrl:url withOriginalUrl:originalUrl];
             */
        } else if (result.hasIpv6Address) {
            //使用ip
            NSString *ip = result.firstIpv6Address;
            [self replaceRequestForIP:ip fromUrl:url withOriginalUrl:originalUrl];
            
            //使用ip列表
            NSArray<NSString *> *ips = result.ipv6s;
            //根据业务场景进行ip使用
            /*
             * NSString *ip = result.ipv6s.firstObject;
             * request = [self replaceRequestForIP:ip fromUrl:url withOriginalUrl:originalUrl];
             */
        } else {
            //无有效ip
        }
    }
    
    // NSURLSession例子
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURLSessionTask *task = [session dataTaskWithRequest:self.request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            NSLog(@"response: %@", response);
            NSLog(@"data: %@", data);
        }
    }];
    [task resume];
}

-(void)replaceRequestForIP:(NSString *)ip fromUrl:(NSURL *)url withOriginalUrl:(NSString *)originalUrl {
    
    // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
    NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", ip, url.host);
    NSRange hostFirstRange = [originalUrl rangeOfString:url.host];
    if (NSNotFound != hostFirstRange.location) {
        NSString *newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
        NSLog(@"New URL: %@", newUrl);
        self.request.URL = [NSURL URLWithString:newUrl];
        [self.request setValue:url.host forHTTPHeaderField:@"host"];
    }
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

#pragma mark - NSURLSessionTaskDelegate
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

@end
