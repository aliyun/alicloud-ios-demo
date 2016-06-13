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
            NSMutableData* mutableData=[NSMutableData dataWithLength:100];
            NSInputStream* instream=[NSInputStream inputStreamWithData:mutableData];
            NSDictionary *sslSettings =[NSDictionary dictionaryWithObjectsAndKeys:url.host,(__bridge id)kCFStreamSSLPeerName, nil];
            [instream setProperty:sslSettings forKey:(__bridge NSString*)kCFStreamPropertySSLSettings];
            [instream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [instream open];
            [self.request setHTTPBodyStream:instream];
            [self.request setValue:url.host forHTTPHeaderField:@"host"];
        }
    }
    
//    NSHTTPURLResponse* response;
//    Method originalMethod=class_getInstanceMethod([NSURLConnection class], @selector(connection:willSendRequestForAuthenticationChallenge:));
//    Method swappedMethod=class_getInstanceMethod([NSURLConnection class], @selector(hda_connection:willSendRequestForAuthenticationChallenge:));
//    method_exchangeImplementations(originalMethod, swappedMethod);
    NSURLConnection* connection=[[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES];
//    NSData* data = [NSURLConnection sendSynchronousRequest:self.request returningResponse:&response error:nil];
    
//    NSLog(@"response %@",response);
    
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
//            /*
//             * 验证失败，取消这次验证流程
//             */
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
    } else {
        /*
         * 对于其他验证方法直接进行处理流程
         */
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}
- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain
{
//    domain=@"book.douban.com";
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
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    NSLog(@"receive data:%@",data);
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"receive response:%@",response);
}
@end
