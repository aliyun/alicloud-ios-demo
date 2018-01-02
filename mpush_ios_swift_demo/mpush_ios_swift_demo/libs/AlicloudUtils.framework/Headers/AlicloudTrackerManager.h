//
//  AlicloudTrackerManager.h
//  AlicloudUtils
//
//  Created by junmo on 2017/7/4.
//  Copyright © 2017年 Ali. All rights reserved.
//

#ifndef AlicloudTrackerManager_h
#define AlicloudTrackerManager_h

#import "AlicloudTracker.h"

@interface AlicloudTrackerManager : NSObject

/**
 获取上报通道管理器对象，并初始化UT
 
 @return 管理器对象
 */
+ (instancetype)getInstance;

/**
 根据SDK标识和版本号获取上报通道
 
 @param sdkId SDK标识
 @param version SDK版本号
 @return 上报通道对象
 */
- (AlicloudTracker *)getTrackerBySdkId:(NSString *)sdkId version:(NSString *)version;

@end

#endif /* AlicloudTrackerManager_h */
