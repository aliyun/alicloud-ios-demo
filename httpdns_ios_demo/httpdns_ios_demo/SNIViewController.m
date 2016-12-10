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


@interface SNIViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSMutableURLRequest *request;
@end

@implementation SNIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSURLProtocol registerClass:[CFHTTPDNSHTTPProtocol class]];
    
//    NSString *urlString = @"https://www.aliyun.com";
        NSString *urlString = @"https://dou.bz/23o8PS";
    //    NSString *urlString = @"https://www.taobao.com";
    //    NSString *urlString = @"https://www.tmall.com";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    // NSURLConnection例子
    // [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES];
    
    // NSURLSession例子
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSArray *protocolArray = @[ [CFHttpMessageURLProtocol class] ];
//    configuration.protocolClasses = protocolArray;
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLSessionTask *task = [session dataTaskWithRequest:_request];
//    [task resume];
    
    // 注*：使用NSURLProtocol拦截NSURLSession发起的POST请求时，HTTPBody为空。
    // 解决方案有两个：1. 使用NSURLConnection发POST请求。
    // 2. 先将HTTPBody放入HTTP Header field中，然后在NSURLProtocol中再取出来。
    // 下面主要演示第二种解决方案
    // NSString *postStr = [NSString stringWithFormat:@"param1=%@&param2=%@", @"val1", @"val2"];
    // [_request addValue:postStr forHTTPHeaderField:@"originalBody"];
    // _request.HTTPMethod = @"POST";
    // NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // NSArray *protocolArray = @[ [CFHttpMessageURLProtocol class] ];
    // configuration.protocolClasses = protocolArray;
    // NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    // NSURLSessionTask *task = [session dataTaskWithRequest:_request];
    // [task resume];
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
