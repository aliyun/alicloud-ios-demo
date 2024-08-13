//
//  AppDelegate.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/5.
//

#import "AppDelegate.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //鉴权方式初始化
    int accountId           = [HTTPDNSDemoUtils accountId];
    NSString *secretKey     = [HTTPDNSDemoUtils secretKey];
    HttpDnsService *httpdns = [[HttpDnsService alloc] initWithAccountID:accountId secretKey:secretKey];

    // 是否允许返回过期的IP
    [httpdns setReuseExpiredIPEnabled:[HTTPDNSDemoUtils settingInfoBool:settingInfoReuseExpiredIPKey]];

    // 是否开启持久化缓存
    [httpdns setPersistentCacheIPEnabled:[HTTPDNSDemoUtils settingInfoBool:settingInfoPersistentCacheKey]];

    // 是否允许HTTPS
    [httpdns setHTTPSRequestEnabled:[HTTPDNSDemoUtils settingInfoBool:settingInfoHTTPSRequestKey]];

    // 是否开启网络切换自动刷新
    [httpdns setPreResolveAfterNetworkChanged:[HTTPDNSDemoUtils settingInfoBool:settingInfoPreResolveAfterNetworkChangedKey]];

    // 是否打开HTTPDNS Log，线上建议关闭
    [httpdns setLogEnabled:[HTTPDNSDemoUtils settingInfoBool:settingInfoLogEnabledKey]];

    // 设置Region
    [httpdns setRegion:[HTTPDNSDemoUtils settingInfo:settingInfoRegionKey]];

    return YES;
}

@end
