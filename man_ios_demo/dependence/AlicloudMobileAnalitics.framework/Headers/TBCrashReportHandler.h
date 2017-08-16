//
//  TBCrashReportHandler.h
//  TBCrashReporter
//
//  Created by qiulibin on 15/10/27.
//  Copyright © 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "CrashReporter.h"
#import <CrashReporter/CrashReporter.h>

@interface TBCrashReportHandler : NSObject

+ (instancetype)shareInstance;

-(void) handle_crash_report:(int)iFlag PLCrashReporter:(PLCrashReporter *)crashReporter iSMerge:(BOOL)isMergeCrashReport;

- (void) handle_repeat_crash_report:(PLCrashReporter*) crashReporter;

- (void) handle_catched_crash_report:(NSString*) crashReport;

@end

