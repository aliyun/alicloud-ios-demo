//
//  MANClientRequest.m
//  man_ios_demo
//
//  Created by nanpo.yhl on 15/10/10.
//  Copyright (c) 2015年 com.aliyun.mobile. All rights reserved.
//

#import "MANClientRequest.h"

@implementation MANClientRequest

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // 由于NSURLConnection封装性，已然看不到TCP连接过程，所以统计不到建连时间
    // 如果自实现socket情况下，可以额外再TCP连接成功的时刻调用如下代码，统一TCP建连时间
    // [_bulider connectFinished];
    
    // 首字节响应埋点
    [_bulider requestFirstBytes];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_mutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // 结束请求打点
    [_bulider requestEndWithBytes:_mutableData.length];
    // 组装日志并发送
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    [tracker send:[_bulider build]];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    ALBBMANNetworkError *networkError = [[ALBBMANNetworkError alloc] initWithErrorCode:[NSString stringWithFormat:@"%ld", (long)error.code]];
    [_bulider requestEndWithError:networkError];
    // 组装日志并发送
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    [tracker send:[_bulider build]];
}

@end
