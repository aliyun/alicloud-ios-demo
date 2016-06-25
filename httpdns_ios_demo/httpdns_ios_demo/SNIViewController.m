//
//  SNIViewController.m
//  httpdns_ios_demo
//
//  SNI应用场景
//  Created by fuyuan.lfy on 16/6/23.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "SNIViewController.h"
#import "NetworkManager.h"
#import "CFHttpMessageURLProtocol.h"
#import <AlicloudHttpDNS/Httpdns.h>

@interface SNIViewController ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (nonatomic, strong) NSMutableURLRequest* request;
@end

static HttpDnsService *httpdns;

@implementation SNIViewController

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
    NSArray *preResolveHosts = @[@"www.aliyun.com", @"www.taobao.com", @"gw.alicdn.com", @"www.tmall.com"];
    // 设置预解析域名列表
    [httpdns setPreResolveHosts:preResolveHosts];
    
    NSString *originalUrl = @"https://dou.bz/23o8PS";
//    NSString* originalUrl = @"https://www.apple.com";
    NSURL* url = [NSURL URLWithString:originalUrl];
    self.request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString* ip = [[HttpDnsService sharedInstance] getIpByHost:url.host];
    // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
    if (ip) {
        NSLog(@"Get IP from HTTPDNS Successfully!");
        NSRange hostFirstRange = [originalUrl rangeOfString: url.host];
        if (NSNotFound != hostFirstRange.location) {
            NSString* newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
            self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
            [_request setValue:url.host forHTTPHeaderField:@"host"];
        }
    }
    
    //NSURLConnection例子
//    [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES];
    
    //NSURLSession例子
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSArray* protocolArray = @[[CFHttpMessageURLProtocol class]];
    configuration.protocolClasses = protocolArray;
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask* task = [session dataTaskWithRequest:_request];
    [task resume];
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

#pragma mark NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"receive data:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"receive response:%@",response);
}

-(NSURLRequest*)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
    return request;
}

#pragma mark NSURLSessionDataDelegate
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    NSLog(@"data: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    NSLog(@"response: %@",response);
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error) {
        NSLog(@"error: %@",error);
    }else
        NSLog(@"complete");
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
