//
//  TBCrashReportMonitor.h
//  CrashReporterDemo
//
//  Created by 贾复 on 15/3/16.
//  Copyright (c) 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CrashReporterMonitorDelegate <NSObject>

@optional
- (void)crashReporterLog:(id)loger;

/**
 *  数据上报额外信息提供
 *
 *  @return 额外信息
 */
- (NSDictionary *)crashReporterAdditionalInformation;

@end


@interface TBCrashReporterMonitor : NSObject

+ (instancetype)sharedMonitor;

/**
 *  额外信息拉取，业务方不要调用
 *
 *  @return 额外信息
 */
- (NSDictionary *)crashReportCallBackInfo:(NSString*)viewControllerInfo Count:(int)count UploadFlag:(int)flag;

/**
 *  注册monitor，monitor实现CrashReporterMonitorDelegate里的方法提供额外信息
 *
 *  @param monitor 监视器
 */
- (void)registerCrashLogMonitor:(id<CrashReporterMonitorDelegate>)monitor;

@end
