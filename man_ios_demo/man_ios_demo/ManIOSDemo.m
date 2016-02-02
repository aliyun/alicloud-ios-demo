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
 *Crash回调实例
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
        [self asyncNetworkHit];
    });
}

/**
 *	@brief	
    账号信息埋点，见文档4.1
 */
- (void)userRegister {
    ALBBMANAnalytics *analytics = [ALBBMANAnalytics getInstance];
    // 注册用户埋点
    [analytics userRegister:@"userNick"];
    // 用户登录埋点
    [analytics updateUserAccount:@"userNick" userid:@"userId"];
    // 用户注销埋点
    [analytics updateUserAccount:@"" userid:@""];
}

/**
 *	@brief	
    页面埋点，见文档4.2
 */
- (void)pageHit {
    // 产生页面日志的另一种方法
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
    // 设置自定义事件扩展参数
    [customBuilder setProperty:@"ckey0" value:@"value0"];
    [customBuilder setProperty:@"ckey1" value:@"value1"];
    [customBuilder setProperty:@"ckey2" value:@"value2"];
    ALBBMANTracker *traker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    // 组装日志并发送
    NSDictionary *dic = [customBuilder build];
    [traker send:dic];
}

/**
 *	@brief	
    自定义性能事件埋点，见文档5.2
 */
- (void)customPerfHit {
    ALBBMANCustomPerformanceHitBuilder *customPerfBuilder = [[ALBBMANCustomPerformanceHitBuilder alloc] init:@"HomeActivityInit"];
    // 自定义性能事件开始
    [customPerfBuilder hitStart];
    [self timeConsume:1234];
    // 自定义性能事件结束
    [customPerfBuilder hitEnd];
    // 设置扩展参数
    [customPerfBuilder setProperty:@"Page" value:@"Home"];
    ALBBMANTracker *traker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    // 组装日志并发送
    [traker send:[customPerfBuilder build]];
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
        ALBBMANNetworkError *networkError = [[ALBBMANNetworkError alloc] initWithErrorCode:[NSString stringWithFormat:@"%ld",(long)error.code]];
        // 自定义网络异常附加信息
        [networkError setValue:@"1.2.3.4" forKey:@"IP"];
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
        [networkError setValue:@"1.2.3.4" forKey:@"IP"];
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
    NSURL *URL = [NSURL URLWithString:@"http://www.taobaobao.com/"];
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
    crashHandler关闭和回调设置，见文档5.3
 */
- (void)crashHandler {
    ALBBMANAnalytics *analytics = [ALBBMANAnalytics getInstance];
    // 设置crash回调方法
    TestCrashCaught *crashCaught = [[TestCrashCaught alloc] init];
    [analytics setCrashCaughtListener:crashCaught];
    // 关闭crashHandler
    [analytics turnOffCrashHandler];
}

@end
