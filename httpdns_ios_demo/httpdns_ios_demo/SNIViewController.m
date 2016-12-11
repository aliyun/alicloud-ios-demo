//
// SNIViewController.m
// httpdns_ios_demo
//
// SNI应用场景
// Created by junmo on 16/12/8.
// Copyright © 2016年 junmo. All rights reserved.
//

#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "NetworkManager.h"
#import "SNIViewController.h"
#import "CFHTTPDNSHTTPProtocol.h"

/**
 *  本示例用于演示HTTPS SNI场景下HTTPDNS的处理方式。
 *  场景包括：WebView加载、基于NSURLConnection加载、基于NSURLSession加载；
 *  WebView加载请求场景，HTTPDNS域名解析必须在拦截请求后进行；
 *  NSURLConnection/NSURLSession加载请求场景，可在发起请求前或拦截请求后进行HTTPDNS域名解析；
 *  Demo为实现统一的NSURLProtocol，统一在`CFHTTPDNSProtocol`拦截请求后进行HTTPDNS域名解析。
 *  由于在SNI场景下，网络请求必须基于底层CFNetwork完成，建议不要拦截非SNI场景的网络请求，尽可能走上层网络库发送网络请求。
 */
@interface SNIViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SNIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSURLProtocol registerClass:[CFHTTPDNSHTTPProtocol class]];
    NSString *urlString = @"https://dou.bz/23o8PS";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    /*
     *  WebView加载资源场景
     */
    [self.webView loadRequest:request];
    
    /*
     *  NSURLConnection加载资源场景
     */
    //[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    /*
     *  NSURLSession加载资源场景
     */
    //NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //NSArray *protocolArray = @[ [CFHTTPDNSHTTPProtocol class] ];
    //configuration.protocolClasses = protocolArray;
    //NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    //NSURLSessionTask *task = [session dataTaskWithRequest:request];
    //[task resume];
    
    // 注*：使用NSURLProtocol拦截NSURLSession发起的POST请求时，HTTPBody为空。
    // 解决方案有两个：1. 使用NSURLConnection发POST请求。
    // 2. 先将HTTPBody放入HTTP Header field中，然后在NSURLProtocol中再取出来。
    // 下面主要演示第二种解决方案
    //NSString *postStr = [NSString stringWithFormat:@"param1=%@&param2=%@", @"val1", @"val2"];
    //[request addValue:postStr forHTTPHeaderField:@"originalBody"];
    //request.HTTPMethod = @"POST";
    //NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //NSArray *protocolArray = @[ [CFHTTPDNSHTTPProtocol class] ];
    //configuration.protocolClasses = protocolArray;
    //NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    //NSURLSessionTask *task = [session dataTaskWithRequest:request];
    //[task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    // 取消注册NSURLProtocol，避免拦截其他场景的请求
    [NSURLProtocol unregisterClass:[CFHTTPDNSHTTPProtocol class]];
    [super viewDidDisappear:animated];
}

#pragma mark NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"receive data:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"receive response:%@", response);
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    return request;
}

#pragma mark NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"response: %@", response);
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"error: %@", error);
    }
    else
        NSLog(@"complete");
}

@end
