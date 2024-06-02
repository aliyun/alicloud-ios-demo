//
//  HTTPSWithSNIScene.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/5/24.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "HTTPSWithSNIScene.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "HttpDnsNSURLProtocolImpl.h"

@implementation HTTPSWithSNIScene

+ (void)httpDnsQueryWithURL:(NSString *)originalUrl completionHandler:(void(^)(NSString * message))completionHandler {
    // 组装提示信息
    __block NSMutableString *tipsMessage = [NSMutableString string];

    // 初始化httpdns实例
    HttpDnsService *httpDnsService = [HttpDnsService sharedInstance];

    // 异步网络请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:originalUrl];
        NSMutableURLRequest *request;

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
                request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
                // 设置请求HOST字段
                [request setValue:url.host forHTTPHeaderField:@"host"];
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
        [self sendRequest:request host:url.host completionHandler:^(NSString *message) {
            [tipsMessage appendFormat:@"\n\n %@",message];
            if (completionHandler) {
                completionHandler(tipsMessage);
            }
        }];
    });
}

+ (void)sendRequest:(NSURLRequest *)request host:(NSString *)host completionHandler:(void(^)(NSString * message))completionHandler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [configuration setProtocolClasses:@[[HttpDnsNSURLProtocolImpl class]]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];

    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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

@end
