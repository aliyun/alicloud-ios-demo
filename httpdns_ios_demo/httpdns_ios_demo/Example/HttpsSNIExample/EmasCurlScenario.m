//
//  EmasCurlScenario.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2025/10/31.
//

#import "EmasCurlScenario.h"
#import <EMASCurl/EMASCurl.h>
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

// 实现自定义DNS解析器（例如使用HTTPDNS）
@interface MyDNSResolver : NSObject <EMASCurlProtocolDNSResolver>
@end

@implementation MyDNSResolver

+ (NSString *)resolveDomain:(NSString *)domain {
    HttpDnsService *httpdns = [HttpDnsService sharedInstance];
    HttpdnsResult* result = [httpdns resolveHostSyncNonBlocking:domain byIpType:HttpdnsQueryIPTypeAuto];
    NSLog(@"httpdns resolve result: %@", result);
    if (result) {
        if(result.hasIpv4Address || result.hasIpv6Address) {
            NSMutableArray<NSString *> *allIPs = [NSMutableArray array];
            if (result.hasIpv4Address) {
                [allIPs addObjectsFromArray:result.ips];
            }
            if (result.hasIpv6Address) {
                [allIPs addObjectsFromArray:result.ipv6s];
            }
            NSString *combinedIPs = [allIPs componentsJoinedByString:@","];
            return combinedIPs;
        }
    }
    return nil;
}

@end

@implementation EmasCurlScenario

+ (void)httpDnsQueryWithURL:(NSString *)originalUrl completionHandler:(void(^)(NSString * message))completionHandler {
    // 创建EMASCurl配置
    EMASCurlConfiguration *curlConfig = [EMASCurlConfiguration defaultConfiguration];
    curlConfig.dnsResolver = [MyDNSResolver class];  // 设置DNS解析器
    curlConfig.connectTimeoutInterval = 3.0;  // 3秒连接超时

    // 创建并配置NSURLSession
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    [EMASCurlProtocol installIntoSessionConfiguration:sessionConfig withConfiguration:curlConfig];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:originalUrl]];

    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSString *errorStr = [NSString stringWithFormat:@"Http request failed with error: %@", error];
            if (completionHandler) {
                completionHandler(errorStr);
            }
            return;
        }

        NSMutableString *message = [NSMutableString string];
        NSString *responseStr = [NSString stringWithFormat:@"HttpResponse: %@", response.description];

        [message appendFormat:@"\n\n%@", responseStr];

        NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [message appendFormat:@"\n\nHttpResponseData:\n %@", dataStr];

        if (completionHandler) {
            completionHandler(message);
        }
        NSLog(@"response data: %@", dataStr);
    }];
    [task resume];
}

@end
