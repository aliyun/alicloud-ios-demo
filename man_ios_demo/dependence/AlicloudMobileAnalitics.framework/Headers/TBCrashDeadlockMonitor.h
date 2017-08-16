//
//  TBCrashDeadlockMonitor.h
//  TBCrashReporter
//
//  Created by 贾复 on 15/3/26.
//  Copyright (c) 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "CrashReporter.h"

#import <CrashReporter/CrashReporter.h>

#import "TBCrashReporterUtility.h"

@protocol TBCrashDeadlockMonitorDelegate <NSObject>

@optional

/**
 *  上报死锁时调用堆栈
 *
 *  @param backtrace 堆栈
 */
- (void)handleDeadlockBacktrace:(NSString*)pl_backtrace;

@end

@interface TBCrashDeadlockMonitor : NSObject

@property (nonatomic, assign) id<TBCrashDeadlockMonitorDelegate> delegate;

// keep hash code of current locked trace to avoid duplicate track(in case that one page is locked for quite while)
@property(nonatomic, assign) NSUInteger currentDeadLockTraceHash;

+ (instancetype)sharedMonitor;

/**
 *  开启监控
 */
- (void)startDeadlockMonitor;

/**
 *  关闭监控
 */
- (void)stopDeallockMonitor;

/**
 *  设置死锁周期
 *
 *  @param watchdogInterval 死锁时间周期（PS：这个值设小了会把有些正常人物误认为死锁，设大了在检测到死锁时用户可能强退导致不能上报数据，默认为5s）
 */
- (void)setWatchdogInterval:(NSTimeInterval)watchdogInterval;


/**
 *
 *
 */
- (void)setCrashReporter:(PLCrashReporter *)crashReporter;

@end
