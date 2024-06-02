//
//  HTTPSScene.m
//  httpdns_ios_demo
//
//  Created by chenyilong on 12/9/2017.
//  Copyright © 2017 alibaba. All rights reserved.
//

#import "HTTPSScene.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

@interface HTTPSScene () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
@property (nonatomic, strong) NSMutableURLRequest *request;
@end

@implementation HTTPSScene

- (void)httpDnsQueryWithURL:(NSString *)originalUrl completionHandler:(void(^)(NSString * message))completionHandler {
    // 组装提示信息
    __block NSMutableString *tipsMessage = [NSMutableString string];

    // 初始化httpdns实例
    HttpDnsService *httpDnsService = [HttpDnsService sharedInstance];

    // 异步网络请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:originalUrl];
        HttpdnsResult *result = [httpDnsService resolveHostSyncNonBlocking:url.host byIpType:HttpdnsQueryIPTypeBoth];
        NSLog(@"resolve result: %@", result);
        NSString *resolvedIpAddress = nil;

        if (result) {
            if (result.hasIpv4Address) {
                // 使用ip
                resolvedIpAddress = result.firstIpv4Address;

                // 使用ip列表
                // NSArray<NSString *> *ips = result.ips;
                // 根据业务场景进行ip使用
                // resolvedIpAddress = result.ips.firstObject;
            } else if (result.hasIpv6Address) {
                // 使用ip
                resolvedIpAddress = result.firstIpv6Address;

                // 使用ip列表
                // NSArray<NSString *> *ips = result.ipv6s;
                // 根据业务场景进行ip使用
                // resolvedIpAddress = result.ipv6s.firstObject;
            } else {
                // 无有效ip
            }
        }

        if (resolvedIpAddress) {
            // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
            NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", resolvedIpAddress, url.host);
            [tipsMessage appendFormat:@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", resolvedIpAddress, url.host];

            NSRange hostFirstRange = [originalUrl rangeOfString:url.host];
            if (NSNotFound != hostFirstRange.location) {
                NSString *newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:resolvedIpAddress];
                NSLog(@"New URL: %@", newUrl);
                self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
                // 设置请求HOST字段
                [self.request setValue:url.host forHTTPHeaderField:@"host"];
            }
        } else {
            NSLog(@"Get IP for host(%@) from HTTPDNS failed!", url.host);
            [tipsMessage appendFormat:@"Get IP for host(%@) from HTTPDNS failed!", url.host];

            if (completionHandler) {
                completionHandler(tipsMessage);
            }
            return;
        }

        // 发送网络请求
        [self sendRequestForHost:url.host completionHandler:^(NSString *message) {
            [tipsMessage appendFormat:@"\n\n %@",message];
            if (completionHandler) {
                completionHandler(tipsMessage);
            }
        }];
    });
}

- (void)sendRequestForHost:(NSString *)host completionHandler:(void(^)(NSString * message))completionHandler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

    NSURLSessionTask *task = [session dataTaskWithRequest:self.request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            NSMutableString *message = [NSMutableString string];
            NSString *responseStr = [NSString stringWithFormat:@"response: %@",response];
            if (responseStr != nil) {
                [message appendFormat:@"\n\n %@",responseStr];
            }
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if (dataStr != nil) {
                [message appendFormat:@"\n\n data:\n %@",dataStr];
            }

            if (completionHandler) {
                completionHandler(message);
            }
            NSLog(@"response: %@", response);
            NSLog(@"data: %@", data);
        }
    }];
    [task resume];
}

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain {
    // 创建证书校验策略
    NSMutableArray *policies = [NSMutableArray array];
    if (domain) {
        [policies addObject:(__bridge_transfer id) SecPolicyCreateSSL(true, (__bridge CFStringRef) domain)];
    } else {
        [policies addObject:(__bridge_transfer id) SecPolicyCreateBasicX509()];
    }

    // 绑定校验策略到服务端的证书上
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef) policies);
    // 评估当前serverTrust是否可信任，官方建议在result = kSecTrustResultUnspecified 或 kSecTrustResultProceed的情况下serverTrust可以被验证通过，https://developer.apple.com/library/ios/technotes/tn2232/_index.html
    // 关于SecTrustResultType的详细信息请参考SecTrust.h
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

    // 获取原始域名信息。
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
