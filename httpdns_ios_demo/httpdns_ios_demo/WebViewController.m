//
//  WebViewController.m
//  httpdns_ios_demo
//
//  Created by fuyuan.lfy on 16/6/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WebViewController.h"
#import "NetworkManager.h"
#import "CFHttpMessageURLProtocol.h"
#import <AlicloudHttpDNS/Httpdns.h>

@interface WebViewController ()<UIWebViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) NSMutableURLRequest* failRequest;
@property (nonatomic, strong) NSURLConnection* connection;
@end

static HttpDnsService *httpdns;

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化HTTPDNS
    httpdns = [HttpDnsService sharedInstance];
    
    // 设置AccoutID
    [httpdns setAccountID:139450];
    
    // 为HTTPDNS服务设置降级机制
    [httpdns setDelegateForDegradationFilter:(id<HttpDNSDegradationDelegate>)self];
    
    //edited
    NSArray *preResolveHosts = @[@"www.aliyun.com", @"www.taobao.com", @"gw.alicdn.com", @"www.apple.com"];
    // 设置预解析域名列表
    [httpdns setPreResolveHosts:preResolveHosts];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.apple.com"]];
    [req addValue:@"webview" forHTTPHeaderField:@"reqtype"];
//    self.webView.delegate = self;
    [self.webView loadRequest:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    // 假设我们对所有css文件的网络请求进行httpdns解析，这里只会拦截初始的请求，页面内的图片，js，css请求将不会询问该方法
    NSMutableURLRequest* mutableReq = [request mutableCopy];
    if (![mutableReq valueForHTTPHeaderField:@"authenticated"]) {
        NSURL* url = [NSURL URLWithString:request.URL.absoluteString];
        self.failRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        NSString* ip = [[HttpDnsService sharedInstance] getIpByHost:url.host];
        // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
        if (ip) {
            NSLog(@"Get IP from HTTPDNS Successfully!");
            NSRange hostFirstRange = [request.URL.absoluteString rangeOfString: url.host];
            if (NSNotFound != hostFirstRange.location) {
                NSString* newUrl = [request.URL.absoluteString stringByReplacingCharactersInRange:hostFirstRange withString:ip];
                self.failRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
                [_failRequest setValue:url.host forHTTPHeaderField:@"host"];
            }
        }
        _connection = [NSURLConnection connectionWithRequest:_failRequest delegate:self];
        [_connection start];
        [webView stopLoading];
        return NO;
    }else
        return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error: %@",error);
}

#pragma mark NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if (!challenge) {
        return;
    }
    /*
     * URL里面的host在使用HTTPDNS的情况下被设置成了IP，此处从HTTP Header中获取真实域名
     */
    NSString* host = [[_failRequest allHTTPHeaderFields] objectForKey:@"host"];
    if (!host) {
        host = _failRequest.URL.host;
    }
    /*
     * 判断challenge的身份验证方法是否是NSURLAuthenticationMethodServerTrust（HTTPS模式下会进行该身份验证流程），
     * 在没有配置身份验证方法的情况下进行默认的网络请求流程。
     */
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        if ([self evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:host]) {
            /*
             * 验证完以后，需要构造一个NSURLCredential发送给发起方
             */
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        } else {
            /*
             * 验证失败，取消这次验证流程
             */
            //            [[challenge sender] cancelAuthenticationChallenge:challenge];
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    } else {
        /*
         * 对于其他验证方法直接进行处理流程
         */
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [_failRequest addValue:@"True" forHTTPHeaderField:@"authenticated"];
    [connection cancel];
    [_webView loadRequest:_failRequest];
}

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain
{
    /*
     * 创建证书校验策略
     */
    NSMutableArray *policies = [NSMutableArray array];
    if (domain) {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)domain)];
    } else {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
    }
    /*
     * 绑定校验策略到服务端的证书上
     */
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
