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

@interface WebViewController () <WKNavigationDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    BOOL _Authenticated;
}
// @property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) WKWebView* wkWebView;
@property (nonatomic, strong) NSMutableURLRequest* request;

@end
static HttpDnsService* httpdns;
@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    // [self.view addSubview:self.webView];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.apple.com"]];
    // [self.webView loadRequest:req];

    _Authenticated = NO;
    httpdns = [HttpDnsService sharedInstance];
    [httpdns setPreResolveHosts:@[ req.URL.host ]];
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
- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (!_Authenticated) {
        self.request = [navigationAction.request mutableCopy];

        NSString* originalUrl = _request.URL.absoluteString;
        NSURL* url = [NSURL URLWithString:originalUrl];
        // 同步接口获取IP地址，由于我们是用来进行url访问请求的，为了适配IPv6的使用场景，我们使用getIpByHostInURLFormat接口
        NSString* ip = [httpdns getIpByHostAsync:url.host];
        if (ip) {
            // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
            NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", ip, url.host);
            NSRange hostFirstRange = [originalUrl rangeOfString:url.host];
            if (NSNotFound != hostFirstRange.location) {
                NSString* newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
                NSLog(@"New URL: %@", newUrl);
                self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
                [_request setValue:url.host forHTTPHeaderField:@"host"];
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        _Authenticated = YES;
        [webView loadRequest:self.request];
    } else
        decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView*)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential* _Nullable))completionHandler {
    NSLog(@"authentication challenge");
    if (!challenge) {
        return;
    }
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential* credential = nil;
    /*
     * 获取原始域名信息。
     */
    NSString* host = [[self.request allHTTPHeaderFields] objectForKey:@"host"];
    if (!host) {
        host = self.request.URL.host;
    }
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([self evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:host]) {
            disposition = NSURLSessionAuthChallengeUseCredential;
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    // 对于其他的challenges直接使用默认的验证方案
    completionHandler(disposition, credential);
}

- (void)webView:(WKWebView*)webView didFinishNavigation:(WKNavigation*)navigation {
    NSLog(@"did finish");
}

- (void)webView:(WKWebView*)webView didCommitNavigation:(WKNavigation*)navigation {
    NSLog(@"did commit");
}

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString*)domain {
    /*
     * 创建证书校验策略
     */
    NSMutableArray* policies = [NSMutableArray array];
    if (domain) {
        [policies addObject:(__bridge_transfer id) SecPolicyCreateSSL(true, (__bridge CFStringRef) domain)];
    } else {
        [policies addObject:(__bridge_transfer id) SecPolicyCreateBasicX509()];
    }
    /*
     * 绑定校验策略到服务端的证书上
     */
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef) policies);
    /*
     * 评估当前serverTrust是否可信任，
     * 官方建议在result = kSecTrustResultUnspecified 或 kSecTrustResultProceed
     * 的情况下serverTrust可以被验证通过，https://developer.apple.com/library/ios/technotes/tn2232/_index.html
     * 关于SecTrustResultType的详细信息请参考SecTrust.h
     */
    SecTrustResultType result;
    SecTrustEvaluate(serverTrust, &result);
    return (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
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
