//
//  TBCrashDeadLockHandler.h
//  TBCrashReporter
//
//  Created by qiulibin on 15/10/27.
//  Copyright © 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "CrashReporter.h"

#import <CrashReporter/CrashReporter.h>

@interface TBCrashDeadLockHandler : NSObject

+ (instancetype)shareInstance;

- (void)turnOnMainThreadDeadlockMonitorWithDealockInterval:(NSTimeInterval)deadlockInterval PLCrashReporter:(PLCrashReporter *)crashReporter;

- (void)turnOffMainThreadDeadlockMonitor;

@end
