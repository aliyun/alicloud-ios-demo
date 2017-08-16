//
//  TBCrashSelfMonitorControler.h
//  TBCrashReporter
//
//  Created by qiulibin on 15/10/22.
//  Copyright © 2015年 Taobao lnc. All rights reserved.
//

/**
 * 该类实现自身监控及容错：
 * 1、发生crash时发送买点数据
 * 2、将AppVersion写入到本地文件中，防止传递旧的crash文件
 * 3、将UserNick写入到本地文件中，防止二次发送时无userNick
 * 4、将发送标记写入到本地文件中，从后台的数据查看发送时机是crash时发送还是启动时发
 * 5、将crash次数写入到本地文件中，防止应用被不断拉起过程中疯狂发送crash文件（越狱手机会出现）
 */
#import <Foundation/Foundation.h>

@interface TBCrashSelfMonitorControler : NSObject{
@private
    /**File path*/
    NSString *_crashProductLogDirectory;
    /**write file lock*/
    NSLock* _lock;
}

+ (instancetype)shareInstance;

/**
 * 发送标记的更新和读取以及重置
 */
- (int) updateSendFlag;
- (void) resetSendFlag;

/**
 * 本地版本号控制
 */
- (void)updateVersion:(NSString*)appVersion;
- (NSString *)readVersion;

/**
 * 用户名存储，防止二次发送无用户名
 */
- (void) updateUserNick:(NSString*)user_nick;
- (NSString*) readUserNick;

/**
 * 合并相同的crash文件
 */
- (BOOL)isRepeatWithCrashThread:(NSString*)crashThread;
- (BOOL) isNeedSendWithTrigger:(NSDate*)triggerTime;
- (int) getCrashTimes;
- (void) resetRepeatFlag;
- (BOOL) hasPendingRepeatCrashReport;
- (NSData *) loadPendingRepeatCrashReportDataAndReturnError: (NSError **) outError;
- (BOOL) purgePendingRepeatCrashReportAndReturnError: (NSError **) outError;

/**
 * 发送自身监控数据
 */
- (void) sendToServer:(NSObject *)aPageName eventId:(int)aEventId arg1:(NSString *)aArg1 arg2:(NSString *)aArg2 arg3:(NSString *)aArg3 args:(NSDictionary *)aArgs;

@end
