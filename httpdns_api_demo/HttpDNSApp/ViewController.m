//
//  ViewController.m
//  HttpDNSApp
//
//  Created by nanpo.yhl on 15/10/30.
//  Copyright © 2015年 com.aliyun.mobile. All rights reserved.
//

#import "ViewController.h"


#import "NetworkManager.h"
#import "HttpDNSLog.h"
//#import "NSURLConnection+HttpsExtension.h"
#import "HttpDNS.h"
#import <objc/runtime.h>

@interface ViewController ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property(strong,nonatomic)NSMutableURLRequest* request;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 启动HTTPDNS log
    [HttpDNSLog turnOnDebug];
    // 为HTTPDNS服务设置降级机制
    [[HttpDNS instance] setDelegateForDegradationFilter:(id<HttpDNSDegradationDelegate>)self];
    NSString *originalUrl = @"https://dou.bz/23o8PS";
//    NSString* originalUrl=@"https://book.douban.com/annual2015/#2";
//    NSString* originalUrl=@"https://www.aliyun.com";
    NSURL* url = [NSURL URLWithString:originalUrl];
    self.request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString* ip = [[HttpDNS instance] getIpByHost:url.host];
    // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
    if (ip) {
        NSLog(@"Get IP from HTTPDNS Successfully!");
        NSRange hostFirstRange = [originalUrl rangeOfString: url.host];
        if (NSNotFound != hostFirstRange.location) {
            NSString* newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
            self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
            [self.request setValue:url.host forHTTPHeaderField:@"host"];
        }
    }
    
    NSURLConnection* connection=[[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES];
    
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

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"receive data:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"receive response:%@",response);
}
@end
