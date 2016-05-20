//
//  AlicloudReachabilityManager.h
//
//  Created by 亿刀 on 14-1-9.
//  Edited by junmo on 15-5-16
//  Copyright (c) 2014年 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALICLOUD_NETWOEK_STATUS_NOTIFY @"AlicloudNetworkStatusChangeNotify"
#define ALICLOUD_NETWORK_STATUS_WIFISSID_DEFAULT @"bssidDefault"

typedef enum {
    AlicloudNotReachable = 0,
    AlicloudReachableViaWiFi,
    AlicloudReachableVia2G,
    AlicloudReachableVia3G,
    AlicloudReachableVia4G
} AlicloudNetworkStatus;

@interface AlicloudReachabilityManager : NSObject

+ (AlicloudReachabilityManager *)shareInstance;

/**
 *	@brief	返回当前网络状态
 *
 *	@return
 */
- (AlicloudNetworkStatus)currentNetworkStatus;

/**
 *	@brief	返回之前网络状态
 *
 *	@return
 */
- (AlicloudNetworkStatus)preNetworkStatus;

/**
 *	@brief	检测网络是否连通
 *
 *	@return
 */
- (BOOL)checkInternetConnection;

/**
 *	@brief	获取Wifi名
 *
 *	@return
 */
- (NSString *)getWifiSSID;

@end
