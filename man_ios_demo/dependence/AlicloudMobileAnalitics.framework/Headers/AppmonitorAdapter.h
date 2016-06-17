//
//  AppmonitorAdapter.h
//  TBCrashReporter
//
//  Created by hansong.lhs on 15/9/20.
//  Copyright (c) 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppmonitorAdapter : NSObject

+ (instancetype) shareInstance;

//stat
- (void)registWithPage:(NSString* )page monitorPoint:(NSString *)monitorPoint;
- (void)commitStatWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint measureName:(NSString*)measureName value:(int)value;

//counter
- (void)commitWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint value:(double)value;

//alarm
- (void) commitFailWithPage:(NSString*)page monitorPoint:(NSString*)monitorPoint errMsg:(NSString*)err;

@end