//
//  NetworkManager.h
//  httpdns_ios_demo
//
//  Created by ryan on 27/1/2016.
//  Copyright © 2016 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableVia2G,
    ReachableVia3G,
    ReachableVia4G
} _NetworkStatus;

@interface NetworkManager : NSObject

+ (NetworkManager *)instance;

/*
 * 当前网络状态的String描述
 */
- (NSString *)currentStatusString;

/*
 * 如果当前网络是Wifi,
 * 获取到当前网络的ssid
 */
- (NSString *)currentWifiSsid;

/*
 * 判断当前网络状态下
 * 是否处理有Http/Https代理
 */
+ (BOOL) configureProxies;

@end

