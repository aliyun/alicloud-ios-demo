//
//  TBCrashTaobaoController.h
//  TBCrashReporter
//
//  Created by qiulibin on 15/10/23.
//  Copyright © 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBCrashTaobaoController : NSObject


+ (instancetype)shareInstance;

/**
 * 获取meta数据（hotpatchVersion，buildVersion 等等）+ crash获取WindVane的url
 */
- (NSString*)getWVURLData;
- (void)getMetaData:(NSMutableDictionary*) meta;

/**
 * 启动地内存告警
 */
- (void) registLowMemoryObservers;

/**
 * 监测死锁时的埋点和低内存时的埋点等
 */
- (void)registStatWithPage:(NSString* )page monitorPoint:(NSString *)monitorPoint;
- (void)commitStatWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint measureName:(NSString*)measureName value:(int)value;
- (void)commitCounterWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint value:(double)value;
- (void) commitAlarmFailWithPage:(NSString*)page monitorPoint:(NSString*)monitorPoint errMsg:(NSString*)err;

@end

