//
//  CommonScene.m
//  httpdns_ios_demo
//
//  Created by chenyilong on 12/9/2017.
//  Copyright © 2017 alibaba. All rights reserved.
//

#import "CommonScene.h"
#import "NetworkManager.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

@interface CommonScene ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@end


@implementation CommonScene

+ (void)beginQuery:(NSString *)originalUrl {
    // Do any additional setup after loading the view, typically from a nib.
    
    // 初始化HTTPDNS
    HttpDnsService *httpdns = [HttpDnsService sharedInstance];
    
    //自定义超时时间，默认15秒
    //httpdns.timeoutInterval = 15;
    
    // 异步网络请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //        NSString *originalUrl = @"http://www.aliyun.com";
        NSURL *url = [NSURL URLWithString:originalUrl];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        
        HttpdnsResult *result = [httpdns resolveHostSyncNonBlocking:url.host byIpType:HttpdnsQueryIPTypeBoth];
        if (result) {
            if (result.hasIpv4Address) {
                //使用ip
                NSString *ip = result.firstIpv4Address;
                request = [self replaceRequest:request forIP:ip fromUrl:url withOriginalUrl:originalUrl];
                
                //使用ip列表
                NSArray<NSString *> *ips = result.ips;
                //根据业务场景进行ip使用
                /*
                 * NSString *ip = result.ips.firstObject;
                 * request = [self replaceRequest:request forIP:ip fromUrl:url withOriginalUrl:originalUrl];
                 */
            } else if (result.hasIpv6Address) {
                //使用ip
                NSString *ip = result.firstIpv6Address;
                request = [self replaceRequest:request forIP:ip fromUrl:url withOriginalUrl:originalUrl];
                
                //使用ip列表
                NSArray<NSString *> *ips = result.ipv6s;
                //根据业务场景进行ip使用
                /*
                 * NSString *ip = result.ipv6s.firstObject;
                 * request = [self replaceRequest:request forIP:ip fromUrl:url withOriginalUrl:originalUrl];
                 */
            } else {
                //无有效ip
            }
        }
        
        // NSURLSession例子
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            } else {
                NSLog(@"response: %@", response);
                NSLog(@"data: %@", data);
            }
        }];
        [task resume];
        
        // 测试黑名单中的域名
        result = [httpdns resolveHostSyncNonBlocking:@"www.taobao.com" byIpType:HttpdnsQueryIPTypeBoth];
        if (!result) {
            NSLog(@"由于在降级策略中过滤了www.taobao.com，无法从HTTPDNS服务中获取对应域名的IP信息");
        }
    });
}

+(NSMutableURLRequest *)replaceRequest:(NSMutableURLRequest *)request forIP:(NSString *)ip fromUrl:(NSURL *)url withOriginalUrl:(NSString *)originalUrl {
    // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
    NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", ip, url.host);
    NSRange hostFirstRange = [originalUrl rangeOfString:url.host];
    if (NSNotFound != hostFirstRange.location) {
        NSString *newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
        NSLog(@"New URL: %@", newUrl);
        request.URL = [NSURL URLWithString:newUrl];
        [request setValue:url.host forHTTPHeaderField:@"host"];
    }
    return request;
}

/*
 * 降级过滤器，您可以自己定义HTTPDNS降级机制
 */
- (BOOL)shouldDegradeHTTPDNS:(NSString *)hostName {
    NSLog(@"Enters Degradation filter.");
    // 根据HTTPDNS使用说明，存在网络代理情况下需降级为Local DNS
    if ([NetworkManager configureProxies]) {
        NSLog(@"Proxy was set. Degrade!");
        return YES;
    }
    
    // 假设您禁止"www.taobao.com"域名通过HTTPDNS进行解析
    if ([hostName isEqualToString:@"www.taobao.com"]) {
        NSLog(@"The host is in blacklist. Degrade!");
        return YES;
    }
    
    return NO;
}

@end
