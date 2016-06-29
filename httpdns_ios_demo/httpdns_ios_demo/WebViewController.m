//
//  WebViewController.m
//  httpdns_ios_demo
//
//  Created by fuyuan.lfy on 16/6/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WebViewController.h"
#import <AlicloudHttpDNS/Httpdns.h>
@import WebKit;

@interface WebViewController ()<WKNavigationDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    BOOL _Authenticated;
}
//@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) WKWebView* wkWebView;
@property (nonatomic, strong) NSURLConnection* conn;

@end
static HttpDnsService* httpdns;
@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:self.webView];
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.apple.com"]];
//    [self.webView loadRequest:req];
    
    _Authenticated = NO;
    httpdns = [HttpDnsService sharedInstance];
    [httpdns setPreResolveHosts:@[req.URL.host]];
    // 设置AccoutID
    [httpdns setAccountID:139450];
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _wkWebView.navigationDelegate = self;
    [_wkWebView loadRequest:req];
    [self.view addSubview:_wkWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark WKNavigationDelegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if (!_Authenticated) {
        NSMutableURLRequest* mutableReq = [navigationAction.request mutableCopy];
        
        NSString* originalUrl = mutableReq.URL.absoluteString;
        NSURL* url = [NSURL URLWithString:originalUrl];
        // 同步接口获取IP地址，由于我们是用来进行url访问请求的，为了适配IPv6的使用场景，我们使用getIpByHostInURLFormat接口
        NSString* ip = [httpdns getIpByHostAsync:url.host];
        if (ip) {
            // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
            NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", ip, url.host);
            NSRange hostFirstRange = [originalUrl rangeOfString: url.host];
            if (NSNotFound != hostFirstRange.location) {
                NSString* newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
                NSLog(@"New URL: %@", newUrl);
                mutableReq = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
                [mutableReq setValue:url.host forHTTPHeaderField:@"host"];
                //添加originalUrl保存原始URL
                [mutableReq addValue:originalUrl forHTTPHeaderField:@"originalUrl"];
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        _conn = [[NSURLConnection alloc] initWithRequest:mutableReq delegate:self];
        [_conn start];
    }else
        decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [_conn cancel];
    _Authenticated = YES;
    [_wkWebView loadRequest:connection.currentRequest];
}

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
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
