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
        
        /**
         * 异步接口获取IP
         * 为了适配IPv6的使用场景，我们使用 `-[HttpDnsService getIpByHostAsyncInURLFormat:]` 接口
         * 注意：当您使用IP形式的URL进行网络请求时，IPv4与IPv6的IP地址使用方式略有不同：
         *         IPv4: http://1.1.1.1/path
         *         IPv6: http://[2001:db8:c000:221::]/path
         * 因此我们专门提供了适配URL格式的IP获取接口 `-[HttpDnsService getIpByHostAsyncInURLFormat:]`
         * 如果您只是为了获取IP信息而已，可以直接使用 `-[HttpDnsService getIpByHostAsync:]`接口
         */
        
        NSString *ip = [httpdns getIpByHostAsyncInURLFormat:url.host];
        if (ip) {
            // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
            NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", ip, url.host);
            NSRange hostFirstRange = [originalUrl rangeOfString:url.host];
            if (NSNotFound != hostFirstRange.location) {
                NSString *newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
                NSLog(@"New URL: %@", newUrl);
                request.URL = [NSURL URLWithString:newUrl];
                [request setValue:url.host forHTTPHeaderField:@"host"];
            }
        }
        NSHTTPURLResponse* response;
        NSError *error;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (error != nil) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Response: %@",response);
        }
        
        // 测试黑名单中的域名
        ip = [httpdns getIpByHostAsyncInURLFormat:@"www.taobao.com"];
        if (!ip) {
            NSLog(@"由于在降级策略中过滤了www.taobao.com，无法从HTTPDNS服务中获取对应域名的IP信息");
        }
    });
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
