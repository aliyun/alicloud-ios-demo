//
//  AppMonitorSDK.h
//  AppMonitorSDK
//
//  Created by junzhan on 14-9-9.
//  Copyright (c) 2014年 君展. All rights reserved.
//  接口类

#import <Foundation/Foundation.h>
#import "AppMonitorTable.h"
#import "AppMonitorAlarm.h"
#import "AppMonitorCounter.h"
#import "AppMonitorStat.h"

@interface AppMonitor : NSObject

+ (BOOL)isInit;

+ (BOOL) isUTInit;

+ (void) setUTInit;

+ (instancetype)sharedInstance;

/*
 * 设置采样率配置
 * @param jsonStr JSON串
 */
+ (void)setSamplingConfigWithJson:(NSString *)jsonStr;

/**
 *  关闭采样，紧开发调试用。线上版本请勿调用此API
 */
+ (void)disableSample;

/**
 *  设置采样率(默认是 50%) 值范围在[0~10000] (0表示不上传，10000表示100%上传，5000表示50%上传)
 */
+ (void)setSampling:(NSString *)sampling;

////是否开启实时调试模式（与UT同步）
+ (BOOL)isTurnOnRealTimeDebug;
+ (NSString*)realTimeDebugUploadUrl;
+ (NSString*)realTimeDebugId;

+(void) turnOnAppMonitorRealtimeDebug:(NSDictionary *) pDict;
+(void) turnOffAppMonitorRealtimeDebug;

@end
