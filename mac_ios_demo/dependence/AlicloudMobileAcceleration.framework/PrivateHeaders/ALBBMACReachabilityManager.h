//
//  ALBBMACNetworkStatusManager.h
//  ALBBMAC
//
//  Created by 亿刀 on 14-1-9.
//  Copyright (c) 2014年 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NW_NETWOEK_STATUS_NOTIFY @"TBNetworkStatusChangeNotify"
#define NW_NETWORK_STATUS_WIFISSID_DEFAULT @"bssidDefault"

typedef enum {
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableVia2G,
    ReachableVia3G,
    ReachableVia4G
} NetworkStatus;

@interface ALBBMACReachabilityManager : NSObject

+ (ALBBMACReachabilityManager *)shareInstance;

- (NetworkStatus)currentNetworkStatus;

- (NetworkStatus)preNetworkStatus;

- (NSString *) getWifiSSID;
@end
