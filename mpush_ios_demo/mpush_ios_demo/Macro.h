//
//  Macro.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/31.
//  Copyright © 2024 alibaba. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#import "AppDelegate.h"
// 绑定账号缓存key
#define DEVICE_BINDACCOUNT [NSString stringWithFormat:@"%@_bindAccount",testAppKey]
// 角标同步缓存key
#define DEVICE_BADGENUMBER [NSString stringWithFormat:@"%@_badgeAccount",testAppKey]

#define kAppKey @"pushSDKAppkey"
#define kSecretKey @"pushSDKAppSecret"
#define kSDKEnv @"pushSDKEnv"
#define kConfigsHistory @"pushSDKConfigsHistory"

#endif /* Macro_h */
