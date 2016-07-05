//
//  WebViewController.m
//  httpdns_ios_demo
//
//  Created by fuyuan.lfy on 16/6/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WebViewController.h"
#import "WebViewURLProtocol.h"

@interface WebViewController ()

@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) NSMutableURLRequest* request;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 注册拦截请求的NSURLProtocol
    [NSURLProtocol registerClass:[WebViewURLProtocol class]];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.apple.com"]];
    [self.webView loadRequest:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    // 取消注册WebViewURLProtocol，避免拦截其他场景的请求
    [NSURLProtocol unregisterClass:[WebViewURLProtocol class]];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end