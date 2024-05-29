//
//  AFNHttpsScene.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/5/27.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "AFNHttpsScene.h"
#import <AFNetworking/AFNetworking.h>
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

@interface AFNHttpsScene()
@property(nonatomic, copy) NSString *host;
@end

@implementation AFNHttpsScene

- (void)beginQuery:(NSString *)originalUrl completionHandler:(void(^)(NSString * ip, NSString * text))completionHandler {
    // 组装提示信息
    __block NSMutableString *tipsInfo = [NSMutableString string];

    // 初始化httpdns实例
    HttpDnsService *httpdns = [HttpDnsService sharedInstance];

    NSURL *url = [NSURL URLWithString:originalUrl];
    self.host = url.host;

    HttpdnsResult *result = [httpdns resolveHostSyncNonBlocking:url.host byIpType:HttpdnsQueryIPTypeBoth];
    NSLog(@"resolve result: %@", result);
    NSString *validIp = nil;

    if (result) {
        if (result.hasIpv4Address) {
            //使用ip
            validIp = result.firstIpv4Address;

            // 使用ip列表
            // NSArray<NSString *> *ips = result.ips;
            // 根据业务场景进行ip使用
            /*
             * validIp = result.ips.firstObject;
             */
        } else if (result.hasIpv6Address) {
            // 使用ip
            validIp = result.firstIpv6Address;

            // 使用ip列表
            // NSArray<NSString *> *ips = result.ipv6s;
            // 根据业务场景进行ip使用
            /*
             * validIp = result.ipv6s.firstObject;
             */
        } else {
            // 无有效ip
        }
    }

    NSString *requestUrl = originalUrl;
    if (validIp) {
        requestUrl = [originalUrl stringByReplacingOccurrencesOfString:url.host withString:validIp];

        NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", validIp, url.host);
        [tipsInfo appendFormat:@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", validIp, url.host];
    } else {
        NSLog(@"Get IP for host(%@) from HTTPDNS failed!", url.host);
        [tipsInfo appendFormat:@"Get IP for host(%@) from HTTPDNS failed!", url.host];
    }

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];

    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = NO;
    securityPolicy.validatesDomainName = YES;
    manager.securityPolicy = securityPolicy;

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    manager.requestSerializer  = [AFJSONRequestSerializer  serializer];
    manager.requestSerializer.timeoutInterval = 10.0f;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:url.host forHTTPHeaderField:@"host"];

    [manager GET:requestUrl parameters:nil headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (validIp != nil) {
            NSData *data = [[NSData alloc]initWithData:responseObject];
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *responseStr = [NSString stringWithFormat:@"response: %@",dataStr];

            if (responseStr != nil) {
                [tipsInfo appendFormat:@"\n\n %@",responseStr];
            }
        }

        if (completionHandler) {
            completionHandler(validIp,tipsInfo);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];

    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential * _Nullable __autoreleasing * _Nullable credential) {

        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        /*
         * 获取原始域名信息。
         */
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([self evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:self.host]) {
                disposition = NSURLSessionAuthChallengeUseCredential;
            } else {
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            }
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
        return disposition;
    }];
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

@end

