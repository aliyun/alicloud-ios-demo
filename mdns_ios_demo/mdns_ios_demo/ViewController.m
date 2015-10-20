//
//  ViewController.m
//  mdns_ios_demo
//
//  Created by zhouzhuo on 9/14/15.
//  Copyright (c) 2015 zhouzhuo. All rights reserved.
//

#import "ViewController.h"
#import <ALBBSDK/ALBBSDK.h>
#import <AlicloudMobileDNS/Httpdns.h>

@interface ViewController ()

@end

NSString * testAppKey = @"*************";
NSString * testAppSecret = @"******************";

id<ALBBHttpdnsServiceProtocol> httpdns;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // 先初始化ALBBSDK，应当尽早进行
    [[ALBBSDK sharedInstance] asyncInit:testAppKey
                              appSecret:testAppSecret
                                       :^{
                                           NSLog(@"init success!");
                                       } failedCallback:^(NSError *error) {
                                           NSLog(@"init failed, error: %@", error);
                                       }];

    [NSThread sleepForTimeInterval:3];

    // 然后初始化MDNS
    [self initHttpdns];

    // 具体使用示例
    // [self parsingHostByHttpdnsAndRequest:@"http://www.taobao.com"];
}

- (void)initHttpdns {
    [HttpdnsLog enbaleLog];
    httpdns = [HttpDnsServiceProvider getService];

    NSArray * hosts = @[@"www.taobao.com", @"www.aliyun.com"];
    [httpdns setPreResolveHosts:hosts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parsingHostByHttpdnsAndRequest:(NSString *)urlString {
    NSURL * originUrl = [[NSURL alloc] initWithString:urlString];
    NSString * host = [originUrl host];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = nil;

    // httpdns service是单例，初始化后可以任意获取使用
    id<ALBBHttpdnsServiceProtocol> httpdns = [HttpDnsServiceProvider getService];
    NSString * ip = [httpdns getIpByHost:host];

    if (![self isNetworkDelegate] && ip) {
        // 将解析出的ip替换到URL中，不用再走Local
        NSString * newUrlString = [urlString stringByReplacingOccurrencesOfString:host
                                                                       withString:ip];
        NSLog(@"After replacing: %@", newUrlString);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newUrlString]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:10];
        // URL中的host被替换为ip，应当将原始host重新设置到header中，参考文档中的注意事项
        [request setValue:host forHTTPHeaderField:@"Host"];
        data = [NSURLConnection sendSynchronousRequest:request
                                     returningResponse:&response
                                                 error:&error];
    } else { // 如果系统已经设置网络代理，或者Httpdns解析不到结果，就走Local解析方式
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:originUrl
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:10];
        data = [NSURLConnection sendSynchronousRequest:request
                                     returningResponse:&response
                                                 error:&error];
    }
    NSLog(@"result: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    /* Continue to do other things
     ...
     */
}

// 检测是否使用了网络代理
-(BOOL)isNetworkDelegate {
    NSURL* URL = [[NSURL alloc] initWithString:@"http://www.taobao.com"];
    NSDictionary *proxySettings = CFBridgingRelease(CFNetworkCopySystemProxySettings());
    NSArray *proxies = nil;
    proxies = CFBridgingRelease(CFNetworkCopyProxiesForURL((__bridge CFURLRef)URL,
                                                           (__bridge CFDictionaryRef)proxySettings));
    if (proxies.count) {
        NSDictionary *settings = [proxies objectAtIndex:0];
        NSString* host = [settings objectForKey:(NSString *)kCFProxyHostNameKey];
        NSNumber* port = [settings objectForKey:(NSString *)kCFProxyPortNumberKey];
        if (host && port) {
            return YES;
        }
    }
    return NO;
}

@end
