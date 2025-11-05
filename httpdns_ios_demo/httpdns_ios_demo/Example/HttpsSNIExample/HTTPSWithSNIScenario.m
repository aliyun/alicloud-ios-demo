//
//  HTTPSWithSNIScene.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/5/24.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "HTTPSWithSNIScenario.h"
#import <AlicloudHTTPDNS/AlicloudHttpDNS.h>
#import "HttpDnsNSURLProtocolImpl.h"

@implementation HTTPSWithSNIScenario

+ (NSURLSession *)sharedUrlSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

        // 为了处理SNI问题，这里替换了NSURLProtocol的实现
        NSMutableArray *protocolsArray = [NSMutableArray arrayWithArray:configuration.protocolClasses];
        [protocolsArray insertObject:[HttpDnsNSURLProtocolImpl class] atIndex:0];
        [configuration setProtocolClasses:protocolsArray];

        session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    });
    return session;
}

+ (void)httpDnsQueryWithURL:(NSString *)originalUrl completionHandler:(void(^)(NSString * message))completionHandler {
    // 组装提示信息
    __block NSMutableString *tipsMessage = [NSMutableString string];

    NSURL *url = [NSURL URLWithString:originalUrl];
    NSMutableURLRequest *request;

    NSString *resolvedIpAddress = [self resolveAvailableIp:url.host];

    NSString *requestUrl = originalUrl;
    if (resolvedIpAddress) {
        // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
        requestUrl = [originalUrl stringByReplacingOccurrencesOfString:url.host withString:resolvedIpAddress];

        NSString *log = [NSString stringWithFormat:@"Resolve host(%@) by HTTPDNS successfully, result ip: %@", url.host, resolvedIpAddress];
        NSLog(@"%@", log);
        [tipsMessage appendString:log];
    } else {
        NSString *log = [NSString stringWithFormat:@"Resolve host(%@) by HTTPDNS failed, keep original url to request", url.host];
        NSLog(@"%@", log);
        [tipsMessage appendString:log];
    }

    // 设置request
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request setValue:url.host forHTTPHeaderField:@"host"];

    // 发送网络请求
    [self sendRequest:request completionHandler:^(NSString *message) {
        [tipsMessage appendFormat:@"\n\n %@",message];
        if (completionHandler) {
            completionHandler(tipsMessage);
        }
    }];
}

+ (NSString *)resolveAvailableIp:(NSString *)host {
    HttpDnsService *httpDnsService = [HttpDnsService sharedInstance];
    HttpdnsResult *result = [httpDnsService resolveHostSyncNonBlocking:host byIpType:HttpdnsQueryIPTypeAuto];

    NSLog(@"resolve host result: %@", result);
    if (!result) {
        return nil;
    }

    if (result.hasIpv4Address) {
        return result.firstIpv4Address;
    } else if (result.hasIpv6Address) {
        return [NSString stringWithFormat:@"[%@]", result.firstIpv6Address];
    } else {
        return nil;
    }
}

+ (void)sendRequest:(NSURLRequest *)request completionHandler:(void(^)(NSString * message))completionHandler {
    NSURLSession *session = [self sharedUrlSession];
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
