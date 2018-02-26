//
//  AlicloudTracker.h
//  AlicloudUtils
//
//  Created by junmo on 2017/6/30.
//  Copyright © 2017年 Ali. All rights reserved.
//

#ifndef AlicloudTracker_h
#define AlicloudTracker_h

@interface AlicloudTracker : NSObject

@property (nonatomic, copy) NSString *sdkId;
@property (nonatomic, copy) NSString *sdkVersion;

/**
 设置Tracker的通用打点属性，每次上报都携带该参数
 
 @param key     通用属性Key
 @param value   通用属性Value
 */
- (void)setGlobalProperty:(NSString *)key value:(NSString *)value;


/**
 删除Tracker通用打点属性
 
 @param key 通用属性Key
 */
- (void)removeGlobalProperty:(NSString *)key;

/**
 自定义打点上报
 
 @param eventName 事件名
 @param duration 时长
 @param properties 额外参数
 */
- (void)sendCustomHit:(NSString *)eventName
             duration:(long long)duration
           properties:(NSDictionary *)properties;

@end
#endif /* AlicloudTracker_h */
