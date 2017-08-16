//
//  ManIOSDemo.m
//  man_ios_demo
//
//  Created by lingkun on 16/1/31.
//  Copyright © 2016年 com.aliyun.mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlicloudMobileAnalitics/ALBBMAN.h>
#import "ManIOSDemo.h"
#import "MANClientRequest.h"

/**
 * Crash回调实例
 */
@interface TestCrashCaught : NSObject <ALBBMANICrashCaughtListener>

@end

@implementation TestCrashCaught
// Crash回调方法
- (NSDictionary *) onCrashCaught:(NSString *)pCrashReason CallStack:(NSString *)callStack{
    NSMutableDictionary *ltmpDict = [NSMutableDictionary dictionary];
    [ltmpDict setObject:callStack forKey:pCrashReason];
    return ltmpDict;
}

@end

@implementation ManIOSDemo

+ (instancetype)getInstance {
    static id singletoUnstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singletoUnstance) {
            singletoUnstance = [[super allocWithZone:NULL] init];
        }
    });
    
    return singletoUnstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self getInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        ALBBMANAnalytics *man = [ALBBMANAnalytics getInstance];
        // appVersion默认从Info.list的CFBundleShortVersionString字段获取，如果没有指定，可在此设定
        // 如果上述两个地方都没有设定，appVersion为"-"
        [man setAppVersion:@"2.3.1"];
        // 设置渠道（用以标记该app的分发渠道名称），如果不关心可以不设置即不调用该接口，渠道设置将影响控制台【渠道分析】栏目的报表展现
        [man setChannel:@"50"];
    }
    return self;
}

- (void)timeConsume:(int) msecs {
    float secs = (float)msecs / 1000;
    [NSThread sleepForTimeInterval:secs];
}

- (void)oneTest {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self crashHandler];
        [self userRegister];
        [self pageHit];
        [self customHit];
        [self customPerfHit];
        [self syncNetworkHit];
    });
    [self asyncNetworkHit];
}

/**
 *	@brief	
    账号信息埋点，见文档4.1
 */
- (void)userRegister {
    ALBBMANAnalytics *man = [ALBBMANAnalytics getInstance];
    // 注册用户埋点
    [man userRegister:@"userNick"];
    // 用户登录埋点
    [man updateUserAccount:@"userNick" userid:@"userId"];
}

/**
 *	@brief	
    页面埋点，见文档4.2
 */
- (void)pageHit {
    // 页面事件埋点的另一种方法
    ALBBMANPageHitBuilder *pageHitBuilder = [[ALBBMANPageHitBuilder alloc] init];
    // 设置页面refer
    [pageHitBuilder setReferPage:@"pageRefer"];
    // 设置页面名称
    [pageHitBuilder setPageName:@"pageName"];
    // 设置页面停留时间
    [pageHitBuilder setDurationOnPage:100];
    // 设置页面事件扩展参数
    [pageHitBuilder setProperty:@"pagePropertyKey1" value:@"pagePropertyValue1"];
    [pageHitBuilder setProperty:@"pagePropertyKey2" value:@"pagePropertyValue2"];
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    // 获取指定id的ALBBMANTracker
    // ALBBMANTracker *pageTracker = [[ALBBMANAnalytics getInstance] getTracker:@"Page"];
    // 组装日志并发送
    [tracker send:[pageHitBuilder build]];
}

/**
 *	@brief	
    自定义事件埋点，见文档6
 */
- (void)customHit {
    ALBBMANCustomHitBuilder *customBuilder = [[ALBBMANCustomHitBuilder alloc] init];
    // 设置自定义事件标签
    [customBuilder setEventLabel:@"test_event_label"];
    // 设置自定义事件页面名称
    [customBuilder setEventPage:@"test_Page"];
    // 设置自定义事件持续时间
    [customBuilder setDurationOnEvent:12345];
    // 设置自定义事件扩展参数方式1
    [customBuilder setProperty:@"ckey0" value:@"value0"];
    [customBuilder setProperty:@"ckey1" value:@"value1"];
    [customBuilder setProperty:@"ckey2" value:@"value2"];
    // 设置自定义事件扩展参数方式2
    // NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    // [properties setObject:@"value0" forKey:@"ckey0"];
    // [properties setObject:@"value1" forKey:@"ckey1"];
    // [properties setObject:@"value2" forKey:@"ckey2"];
    // [customBuilder setProperties:properties];
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    // 组装日志并发送
    NSDictionary *dic = [customBuilder build];
    [tracker send:dic];
}

/**
 *	@brief	
    自定义性能事件埋点，见文档5.2
 */
- (void)customPerfHit {
    ALBBMANCustomPerformanceHitBuilder *customPerfBuilder = [[ALBBMANCustomPerformanceHitBuilder alloc] init:@"HomeActivityInit"];
    // 记录事件时间方式1，自定义性能事件开始
    [customPerfBuilder hitStart];
    [self timeConsume:1234];
    // 自定义性能事件结束
    [customPerfBuilder hitEnd];
    // 设置定义性能事件持续时间，方式2
    // [customPerfBuilder setDurationIntervalInMillis:1234];
    // 设置扩展参数
    [customPerfBuilder setProperty:@"Page" value:@"Home"];
    // 组装日志并发送
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    [tracker send:[customPerfBuilder build]];
}

/**
 *	@brief	
    同步请求网络性能埋点，见文档5.1
 */
- (void)syncNetworkHit {
    NSURL *URL = [NSURL URLWithString:@"http://www.taobao.com/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:30];
    // 由于NSURLConnection同步接口，封装了TCP连接、首字节的过程，所以同步接口上面我们统计不到TCP建连时间跟首字节时间
    ALBBMANNetworkHitBuilder *bulider = [[ALBBMANNetworkHitBuilder alloc] initWithHost:URL.host method:[request HTTPMethod]];
    
    // 开始请求打点
    [bulider requestStart];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        // 自定义网络异常，见文档5.1.2
        ALBBMANNetworkError *networkError = [[ALBBMANNetworkError alloc] initWithErrorCode:@"1001"];
        // 自定义网络异常附加信息
        [networkError setProperty:@"IP" value:@"1.2.3.4"];
        [bulider requestEndWithError:networkError];
    }
    if (response.statusCode >= 400 && response.statusCode < 600) {
        // 默认网络异常，见文档5.1.2
        ALBBMANNetworkError *networkError;
        if (response.statusCode < 500) {
            networkError = [ALBBMANNetworkError ErrorWithHttpException4];
        } else {
            networkError = [ALBBMANNetworkError ErrorWithHttpException5];
        }
        // 默认网络异常附加信息
        [networkError setProperty:@"IP" value:@"1.2.3.4"];
        [bulider requestEndWithError:networkError];
    }
    else {
        //结束请求打点，bytes是下载的数据量大小
        [bulider requestEndWithBytes:data.length];
    }
    // 组装日志并发送
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    [tracker send:[bulider build]];
}

/**
 *	@brief	
    异步请求网络性能埋点，见文档5.1
 */
- (void)asyncNetworkHit {
    MANClientRequest *client = [[MANClientRequest alloc] init];
    NSURL *URL = [NSURL URLWithString:@"http://www.aliyun.com/"];
    client.request = [[NSMutableURLRequest alloc] initWithURL:URL
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                              timeoutInterval:30];
    client.bulider = [[ALBBMANNetworkHitBuilder alloc] initWithHost:URL.host method:client.request.HTTPMethod];
    client.mutableData = [[NSMutableData alloc] init];
    // 开始打点
    [client.bulider requestStart];
    client.connection = [[NSURLConnection alloc] initWithRequest:client.request delegate:client];
}

/**
 *	@brief	
    crashHandler关闭设置，见文档5.3
 */
- (void)crashHandler {
    ALBBMANAnalytics *man = [ALBBMANAnalytics getInstance];
    // 关闭crashHandler
    [man turnOffCrashHandler];
}

@end
