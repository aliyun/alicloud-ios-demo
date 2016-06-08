//
//  TBCrashDeduplication.h
//  TBCrashReporter
//
//  Created by qiulibin on 15/10/26.
//  Copyright © 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBCrashSelfMonitor.h"

@interface TBCrashDeduplication : NSObject

+ (instancetype) shareInstance;

- (BOOL) isRepeatWithCrashThread:(NSString*)crashThread SelfMonitor:(TBCrashSelfMonitor*) selfMonitor;

- (BOOL) isNeedSendWithTrigger:(NSDate*)triggerTime;

@end
