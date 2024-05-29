//
// AppDelegate.m
// httpdns_ios_demo
//
// Created by ryan on 27/1/2016.
// Copyright © 2016 alibaba. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkManager.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

static int accountID = 139450;
static NSString * secretKey = @"807a19762f8eaefa8563489baf198535";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    // 初始化HTTPDNS
    // 设置AccoutID
    //    HttpDnsService *httpdns = [[HttpDnsService alloc] autoInit];

    //鉴权方式初始化
    HttpDnsService *httpdns = [[HttpDnsService alloc] initWithAccountID:accountID secretKey:secretKey];

    // 打开HTTPDNS Log，调试排查问题时使用，线上建议关闭
    [httpdns setLogEnabled:YES];

    /*
     *  设置HTTPDNS域名解析请求类型(HTTP/HTTPS)，若不调用该接口，默认为HTTP请求；
     *  SDK内部HTTP请求基于CFNetwork实现，不受ATS限制。
     *  设置httpdns域名解析网络请求是否需要走HTTPS方式
     */
     [httpdns setHTTPSRequestEnabled:YES];

    // 设置开启持久化缓存，使得APP启动后可以复用上次活跃时缓存在本地的IP，提高启动后获取域名解析结果的速度
    [httpdns setPersistentCacheIPEnabled:YES];

    // 允许返回过期的IP
    [httpdns setReuseExpiredIPEnabled:YES];

    // 设置底层HTTPDNS网络请求超时时间，单位为秒
    [httpdns setTimeoutInterval:2];

    // 设置是否支持IPv6地址解析，只有开启这个开关，解析接口才有能力解析域名的IPv6地址并返回
    [httpdns setIPv6Enabled:YES];

    // edited
    NSArray *preResolveHosts = @[ @"www.aliyun.com", @"www.taobao.com", @"gw.alicdn.com", @"www.tmall.com", @"dou.bz"];
    // NSArray* preResolveHosts = @[@"pic1cdn.igetget.com"];
    // 设置预解析域名列表
    [httpdns setPreResolveHosts:preResolveHosts];

    // IP 优选功能，设置后会自动对IP进行测速排序，可以在调用 `-resolveHostSyncNonBlocking` 等接口时返回最优IP。
    NSDictionary *IPRankingDatasource = @{
        @"www.aliyun.com" : @80,
        @"www.taobao.com" : @80,
        @"gw.alicdn.com" : @80,
        @"www.tmall.com" : @80,
        @"dou.bz" : @80
    };
    [httpdns setIPRankingDatasource:IPRankingDatasource];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
