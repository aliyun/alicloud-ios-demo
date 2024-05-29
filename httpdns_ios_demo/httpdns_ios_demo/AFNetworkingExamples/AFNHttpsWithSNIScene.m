//
//  AFNHttpsWithSNIScene.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/5/27.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "AFNHttpsWithSNIScene.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "HttpDnsNSURLProtocolImpl.h"
#import <AFNetworking/AFNetworking.h>

@implementation AFNHttpsWithSNIScene

+ (void)beginQuery:(NSString *)originalUrl completionHandler:(void(^)(NSString * ip, NSString * text))completionHandler {
    // 组装提示信息
    __block NSMutableString *tipsInfo = [NSMutableString string];

    // 初始化httpdns实例
    HttpDnsService *httpdns = [HttpDnsService sharedInstance];

    NSURL *url = [NSURL URLWithString:originalUrl];

    HttpdnsResult *result = [httpdns resolveHostSyncNonBlocking:url.host byIpType:HttpdnsQueryIPTypeBoth];
    NSLog(@"resolve result: %@", result);
    NSString *validIp = nil;

    if (result) {
        if (result.hasIpv4Address) {
            // 使用ip
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
    [configuration setProtocolClasses:@[[HttpDnsNSURLProtocolImpl class]]];
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
}

@end
