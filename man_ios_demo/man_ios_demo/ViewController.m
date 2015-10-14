//
//  ViewController.m
//  man_ios_demo
//
//  Created by nanpo.yhl on 15/10/10.
//  Copyright (c) 2015年 com.aliyun.mobile. All rights reserved.
//

#import "ViewController.h"
#import "MANClientRequest.h"

#import <AlicloudMobileAnalitics/ALBBMAN.h>

@interface ViewController ()

@end

@implementation ViewController


-(void)synRequest
{
    NSURL* URL = [NSURL URLWithString:@"http://www.taobao.com/"];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    /*
     * 由于NSURLConnection 同步接口 封装了TCP连接、首字节的过程，所以同步接口上面我们统计不到TCP建连时间跟首字节时间
     */
    
    ALBBMANNetworkHitBuilder* bulider = [[ALBBMANNetworkHitBuilder alloc] initWithHost:URL.host method:[request HTTPMethod]];
    
    // 开始请求打点
    [bulider requestStart];
    
    NSHTTPURLResponse* response;
    NSError* error;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        ALBBMANNetworkError* networkError = [[ALBBMANNetworkError alloc] initWithErrorCode:[NSString stringWithFormat:@"%ld",(long)error.code]];
        
        // 如果你有额外的附加信息
        //[networkError setValue:@"1.2.3.4" forKey:@"IP"];
        [bulider requestEndWithError:networkError];
    } if (response.statusCode >= 400 && response.statusCode < 600) {
        ALBBMANNetworkError* networkError;
        if (response.statusCode < 500) {
            networkError = [ALBBMANNetworkError ErrorWithHttpException4];
        } else {
            networkError = [ALBBMANNetworkError ErrorWithHttpException5];
        }
        
        // 如果你有额外的附加信息
        //[networkError setValue:@"1.2.3.4" forKey:@"IP"];
        [bulider requestEndWithError:networkError];
    }
    else {
        //结束请求打点
        //bytes是下载的数据量大小
        [bulider requestEndWithBytes:data.length];
    }
    
    // 组装数据,上传数据
    
    ALBBMANTracker* tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    [tracker send:[bulider build]];
}

-(void)asyncRequest
{
    MANClientRequest* client = [[MANClientRequest alloc] init];
    NSURL* URL = [NSURL URLWithString:@"http://www.taobao.com/"];
    client.request = [[NSMutableURLRequest alloc] initWithURL:URL
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                              timeoutInterval:30];
    client.bulider = [[ALBBMANNetworkHitBuilder alloc] initWithHost:URL.host method:client.request.HTTPMethod];
    client.mutableData = [[NSMutableData alloc] init];
    
    [client.bulider requestStart];
    
    client.connection = [[NSURLConnection alloc] initWithRequest:client.request delegate:client];
}

-(void)userRegister
{
    ALBBMANAnalytics* analytics = [ALBBMANAnalytics getInstance];
    [analytics userRegister:@"userNick"];
    [analytics updateUserAccount:@"userNick" userid:@"userId"];
    
}

-(void)customPerformHit
{
    ALBBMANCustomPerformanceHitBuilder* builder = [[ALBBMANCustomPerformanceHitBuilder alloc] init:@"HomeActivityInit"];
    [builder hitStart];
    
    /*
     * works
     */
    sleep(1);
    
    
    [builder hitEnd];
    
    [builder setProperty:@"Page" value:@"Home"];
    
    ALBBMANTracker* tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    [tracker send:[builder build]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self synRequest];
    
    [self asyncRequest];
    
    [self customPerformHit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
