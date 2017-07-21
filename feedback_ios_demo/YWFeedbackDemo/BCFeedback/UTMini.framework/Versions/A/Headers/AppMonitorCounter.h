//
//  AppMonitorCounter.h
//  AppMonitor
//
//  Created by junzhan on 14-10-14.
//  Copyright (c) 2014年 君展. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppMonitorBase.h"

@interface AppMonitorCounter : AppMonitorBase

/**
 *  实时计数接口.（每次commit会累加一次count，value也会累加）可用于服务端计算总次数或求平均值。
 *  此接口数据量不应太大，
 *
 *  @param page         操作发生所在的页面
 *  @param monitorPoint 监控点名称
 *  @param value        数值
 */
+ (void)commitWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint value:(double)value;

/**
 *  实时计数接口.（每次commit会累加一次count，value也会累加）可用于服务端计算总次数或求平均值。
 *  此接口数据量不应太大，
 *
 *  @param page         操作发生所在的页面
 *  @param monitorPoint 监控点名称
 *  @param value        数值
 *  @param arg          附加参数
 */
+ (void)commitWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint value:(double)value arg:(NSString *)arg;

@end
