//
//  AFNHttpsScene.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/5/27.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "AFNHttpsScenario.h"
#import <AFNetworking/AFNetworking.h>
#import <AlicloudHTTPDNS/AlicloudHttpDNS.h>

@implementation AFNHttpsScenario

+ (AFHTTPSessionManager *)sharedAfnManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
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

        NSString *log = [NSString stringWithFormat:@"Resolve host(%@) by HTTPDNS successfully, result ip: %@", url.host, resolvedIpAddress];
        NSLog(@"%@", log);
        [tipsMessage appendString:log];
    } else {
        NSString *log = [NSString stringWithFormat:@"Resolve host(%@) by HTTPDNS failed, keep original url to request", url.host];
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

+ (void)sendRequestWithUrl:(NSString *)requestUrl host:(NSString *)host completionHandler:(void(^)(NSString * message))completionHandler {
    AFHTTPSessionManager *manager = [self sharedAfnManager];

    // 因为域名里的host已经被替换成了ip，因此这里需要主动设置host头，确保后端服务识别正确
    [manager.requestSerializer setValue:host forHTTPHeaderField:@"host"];

    // 配置https请求的证书校验策略
    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential * _Nullable __autoreleasing * _Nullable credential) {
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        // 获取原始域名信息。
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([self evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:host]) {
                disposition = NSURLSessionAuthChallengeUseCredential;
            } else {
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            }
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
        return disposition;
    }];

    // 发送请求
    [manager GET:requestUrl parameters:nil headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        // empty
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSString *responseStr = [NSString stringWithFormat:@"HttpResponse: %@", dataStr];

        if (completionHandler) {
            completionHandler(responseStr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionHandler) {
            NSString *errorStr = [NSString stringWithFormat:@"Http request failed with error: %@", error];
            completionHandler(errorStr);
        }
        NSLog(@"error: %@", error);
    }];
}

+ (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
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

@end
