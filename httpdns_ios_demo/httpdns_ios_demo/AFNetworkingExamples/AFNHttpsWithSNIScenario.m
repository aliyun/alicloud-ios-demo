//
//  AFNHttpsWithSNIScene.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/5/27.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "AFNHttpsWithSNIScenario.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "HttpDnsNSURLProtocolImpl.h"
#import <AFNetworking/AFNetworking.h>

@implementation AFNHttpsWithSNIScenario

+ (AFHTTPSessionManager *)sharedAfnManager {
    static AFHTTPSessionManager *manager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

        // 为了处理SNI问题，这里替换了NSURLProtocol的实现
        NSMutableArray *protocolsArray = [NSMutableArray arrayWithArray:configuration.protocolClasses];
        [protocolsArray insertObject:[HttpDnsNSURLProtocolImpl class] atIndex:0];
        [configuration setProtocolClasses:protocolsArray];

        manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];

        AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = NO;
        securityPolicy.validatesDomainName = YES;
        manager.securityPolicy = securityPolicy;

        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
        manager.requestSerializer  = [AFJSONRequestSerializer  serializer];
        manager.requestSerializer.timeoutInterval = 10.0f;
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });

    return manager;
}

+ (void)httpDnsQueryWithURL:(NSString *)originalUrl completionHandler:(void(^)(NSString * message))completionHandler {
    // 组装提示信息
    __block NSMutableString *tipsMessage = [NSMutableString string];

    NSURL *url = [NSURL URLWithString:originalUrl];
    NSString *resolvedIpAddress = [self resolveAvailableIp:url.host];

    NSString *requestUrl = originalUrl;
    if (resolvedIpAddress) {
        requestUrl = [originalUrl stringByReplacingOccurrencesOfString:url.host withString:resolvedIpAddress];

        NSString *log = [NSString stringWithFormat:@"Resolve host(%@) from HTTPDNS successfully, result ip: %@", url.host, resolvedIpAddress];
        NSLog(@"%@", log);
        [tipsMessage appendString:log];
    } else {
        NSString *log = [NSString stringWithFormat:@"Resolve host(%@) from HTTPDNS failed, keep original url to request", url.host];
        NSLog(@"%@", log);
        [tipsMessage appendString:log];
    }

    // 发送网络请求
    [self sendRequestWithUrl:requestUrl host:url.host completionHandler:^(NSString *message) {
        [tipsMessage appendFormat:@"\n\n%@", message];
        if (completionHandler) {
            completionHandler(tipsMessage);
        }
    }];
}

+ (NSString *)resolveAvailableIp:(NSString *)host {
    HttpDnsService *httpDnsService = [HttpDnsService sharedInstance];
    HttpdnsResult *result = [httpDnsService resolveHostSyncNonBlocking:host byIpType:HttpdnsQueryIPTypeBoth];

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

+ (void)sendRequestWithUrl:(NSString *)requestUrl host:(NSString *)host completionHandler:(void(^)(NSString * message))completionHandler {
    AFHTTPSessionManager *manager = [self sharedAfnManager];

    // 设置host头部
    [manager.requestSerializer setValue:host forHTTPHeaderField:@"host"];

    // 由于已经替换了urlprotocol的实现为自定义实现，所以这里不用额外处理证书验证问题
    // 直接发送请求
    [manager GET:requestUrl parameters:nil headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        // keep empty
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSString *responseStr = [NSString stringWithFormat:@"HttpResponse: %@", dataStr];

        if (completionHandler) {
            completionHandler(responseStr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionHandler) {
            NSString *errorStr = [NSString stringWithFormat:@"Http request failed, error: %@", error];
            completionHandler(errorStr);
        }
        NSLog(@"error: %@", error);
    }];
}

@end
