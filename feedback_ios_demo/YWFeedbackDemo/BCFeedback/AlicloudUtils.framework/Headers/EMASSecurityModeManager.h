//
//  EMASSecurityModeManager.h
//  AlicloudUtils
//
//  Created by junmo on 2018/3/10.
//  Copyright © 2018年 Ali. All rights reserved.
//

#ifndef EMASSecurityModeManager_h
#define EMASSecurityModeManager_h

#import "EMASSecurityModeCommon.h"

@interface EMASSecurityModeManager : NSObject

+ (instancetype)sharedInstance;

- (void)registerSDKComponentAndStartCheck:(NSString *)sdkId
                               sdkVersion:(NSString *)sdkVersion
                                   appKey:(NSString *)appKey
                                appSecret:(NSString *)appSecret
                        sdkCrashThreshold:(NSUInteger)crashTimesThreshold
                                onSuccess:(SDKCheckSuccessHandler)successHandler
                                  onCrash:(SDKCheckCrashHandler)crashHandler;

@end

#endif /* EMASSecurityModeManager_h */
