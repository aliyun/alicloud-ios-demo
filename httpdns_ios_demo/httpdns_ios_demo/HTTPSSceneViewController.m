//
//  HTTPSSceneViewController.m
//  httpdns_ios_demo
//
//  Created by fuyuan.lfy on 16/6/23.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "HTTPSSceneViewController.h"
#import "NetworkManager.h"
#import <AlicloudHttpDNS/Httpdns.h>
#import "CFHttpMessageURLProtocol.h"

@interface HTTPSSceneViewController ()<NSURLConnectionDelegate,NSURLSessionTaskDelegate,NSURLConnectionDataDelegate,NSURLSessionDataDelegate>
@property (nonatomic, strong) NSMutableURLRequest* request;
@end

static HttpDnsService *httpdns;
@implementation HTTPSSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化httpdns实例
    httpdns = [HttpDnsService sharedInstance];
    // 设置AccoutID
    [httpdns setAccountID:139450];
    
    // 为HTTPDNS服务设置降级机制
    [httpdns setDelegateForDegradationFilter:(id<HttpDNSDegradationDelegate>)self];
    
    //edited
    NSArray *preResolveHosts = @[@"www.aliyun.com", @"www.taobao.com", @"gw.alicdn.com", @"www.tmall.com"];
    // 设置预解析域名列表
    [httpdns setPreResolveHosts:preResolveHosts];
    //需要设置SNI的URL，证书验证将出错
    NSString *originalUrl = @"https://dou.bz/23o8PS";
    //不需要设置SNI的URL，证书验证没错
//    NSString* originalUrl = @"https://www.aliyun.com";
    NSURL* url = [NSURL URLWithString:originalUrl];
    self.request = [[NSMutableURLRequest alloc] initWithURL:url];
    // 同步接口获取IP地址，由于我们是用来进行url访问请求的，为了适配IPv6的使用场景，我们使用getIpByHostInURLFormat接口
    // 注* 当您使用IP形式的URL进行网络请求时，IPv4与IPv6的IP地址使用方式略有不同：
    // IPv4: http://1.1.1.1/path
    // IPv6: http://[2001:db8:c000:221::]/path
    // 因此我们专门提供了适配URL格式的IP获取接口getIpByHostInURLFormat
    // 如果您只是为了获取IP信息而已，可以直接使用getIpByHost接口
    NSString* ip = [httpdns getIpByHostInURLFormat:url.host];
    if (ip) {
        // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
        NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", ip, url.host);
        NSRange hostFirstRange = [originalUrl rangeOfString: url.host];
        if (NSNotFound != hostFirstRange.location) {
            NSString* newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
            NSLog(@"New URL: %@", newUrl);
            self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
            [self.request setValue:url.host forHTTPHeaderField:@"host"];
        }
    }
    //NSURLConnection例子
//    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES];
    
    //NSURLSession例子
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURLSessionTask* task = [session dataTaskWithRequest:self.request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error){
        if (error) {
            NSLog(@"error: %@", error);
        }else{
            NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if (!challenge) {
        return;
    }
    /*
     * URL里面的host在使用HTTPDNS的情况下被设置成了IP，此处从HTTP Header中获取真实域名
     */
    NSString* host = [[self.request allHTTPHeaderFields] objectForKey:@"host"];
    if (!host) {
        host = self.request.URL.host;
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

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error: %@",error);
}

-(void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSLog(@"cancel authentication");
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"response: %@",response);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"data: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

-(NSURLRequest*)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
    return request;
}

#pragma mark - NSURLSessionTaskDelegate
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    if (!challenge) {
        return;
    }
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
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
            //            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    // 对于其他的challenges直接使用默认的验证方案
    completionHandler(disposition,credential);
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
