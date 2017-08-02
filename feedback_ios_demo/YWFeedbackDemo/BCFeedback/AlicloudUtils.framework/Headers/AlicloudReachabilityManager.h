//
//  AlicloudReachabilityManager.h
//
//  Created by 亿刀 on 14-1-9.
//  Edited by junmo on 15-5-16
//  Copyright (c) 2014年 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#define ALICLOUD_NETWOEK_STATUS_NOTIFY @"AlicloudNetworkStatusChangeNotify"

typedef enum {
    AlicloudNotReachable = 0,
    AlicloudReachableViaWiFi,
    AlicloudReachableVia2G,
    AlicloudReachableVia3G,
    AlicloudReachableVia4G
} AlicloudNetworkStatus;

@interface AlicloudReachabilityManager : NSObject

/**
 *  获取Reachability单例对象
 */
+ (AlicloudReachabilityManager *)shareInstance;

/**
 *  获取Reachability单例对象，为保证全局维护一个netInfo实例，可从外部传入netInfo对象的引用
 *  warn: netInfo多次实例化，有一定几率crash
 *
 */
+ (AlicloudReachabilityManager *)shareInstanceWithNetInfo:(CTTelephonyNetworkInfo *)netInfo;

/**
 *	返回当前网络状态(同步调用，可能会阻塞调用线程)
 */
- (AlicloudNetworkStatus)currentNetworkStatus;

/**
 *	返回之前网络状态
 */
- (AlicloudNetworkStatus)preNetworkStatus;

/**
 *	检测网络是否连通(同步调用，阻塞调用线程)
 */
- (BOOL)checkInternetConnection;

/**
 *	检测Wifi网络是否联通
 */
- (BOOL)isReachableViaWifi;

/**
 *	检测蜂窝网络是否联通
 */
- (BOOL)isReachableViaWWAN;

@end
