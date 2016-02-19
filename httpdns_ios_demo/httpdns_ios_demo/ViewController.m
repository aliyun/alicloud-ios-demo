//
//  ViewController.m
//  httpdns_ios_demo
//
//  Created by ryan on 27/1/2016.
//  Copyright © 2016 alibaba. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#import <AlicloudMobileDNS/Httpdns.h>

@interface ViewController ()

@end

static HttpDnsService *httpdns;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 初始化HTTPDNS
    httpdns = [HttpDnsService sharedInstance];
    
    // 设置AccoutID
    [httpdns setAccountID:100000];
    
    // 为HTTPDNS服务设置降级机制
    [httpdns setDelegateForDegradationFilter:(id<HttpDNSDegradationDelegate>)self];
    
    NSArray *preResolveHosts = @[@"www.aliyun.com", @"www.taobao.com", @"gw.alicdn.com"];
    // 设置预解析域名列表
    [httpdns setPreResolveHosts:preResolveHosts];
    
    // 异步网络请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *originalUrl = @"http://www.aliyun.com/";
        NSURL* url = [NSURL URLWithString:originalUrl];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
        // 同步接口获取IP
        NSString* ip = [httpdns getIpByHost:url.host];
        if (ip) {
            // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
            NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", ip, url.host);
            NSRange hostFirstRange = [originalUrl rangeOfString: url.host];
            if (NSNotFound != hostFirstRange.location) {
                NSString* newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
                request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
                [request setValue:url.host forHTTPHeaderField:@"host"];
            }
        }
        NSHTTPURLResponse* response;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSLog(@"Response: %@",response);
        
        // 允许返回过期的IP
        [httpdns setExpiredIPEnabled:YES];
        // 异步接口获取IP
        ip = [httpdns getIpByHostAsync:url.host];
        if (ip) {
            // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
            NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", ip, url.host);
            NSRange hostFirstRange = [originalUrl rangeOfString: url.host];
            if (NSNotFound != hostFirstRange.location) {
                NSString* newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
                request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
                [request setValue:url.host forHTTPHeaderField:@"host"];
            }
        }
        data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSLog(@"Response: %@",response);
        
        // 测试黑名单中的域名
        ip = [httpdns getIpByHostAsync:@"www.taobao.com"];
        if (!ip) {
            NSLog(@"由于在降级策略中过滤了www.taobao.com，无法从HTTPDNS服务中获取对应域名的IP信息");
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
