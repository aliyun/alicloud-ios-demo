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
    // 初始化httpdns，全局只需要初始化一次
    HttpDnsService *httpdns = [[HttpDnsService alloc] autoInit];
    //鉴权方式初始化
    //HttpDnsService *httpdns = [[HttpDnsService alloc] initWithAccountID:0000 secretKey:@"XXXX"];

    // 允许返回过期的IP
    [httpdns setReuseExpiredIPEnabled:YES];
    // 打开HTTPDNS Log，线上建议关闭
    [httpdns setLogEnabled:YES];
    /*
     *  设置HTTPDNS域名解析请求类型(HTTP/HTTPS)，若不调用该接口，默认为HTTP请求；
     *  SDK内部HTTP请求基于CFNetwork实现，不受ATS限制。
     */
    [httpdns setHTTPSRequestEnabled:YES];

    // 设置预解析域名
    NSArray *preResolveHosts = [HTTPDNSUtils domains];
    [httpdns setPreResolveHosts:preResolveHosts];

    return YES;
}

@end
