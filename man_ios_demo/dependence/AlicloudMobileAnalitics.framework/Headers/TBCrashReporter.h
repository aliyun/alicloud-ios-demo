//
//  TBCrashReporter.h
//  CrashReporterDemo
//
//  Created by 贾复 on 15/3/16.
//  Copyright (c) 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBCrashReporterDelegate <NSObject>

@optional
/**
 *  完整crashreport上传接口
 *
 *  @param plCrashReport 完整crash
 */
- (void)uploadPLCrashReport:(NSString *)plCrashReport;

/**
 *  crash堆栈和原因上传接口
 *
 *  @param backTrace crash堆栈
 *  @param reason    crash原因
 */
- (void)uploadCrashBackTrace:(NSString *)backTrace withReason:(NSString *)reason;

/**
 *  主线程死锁堆栈上报接口
 *
 *  @param backtrace 死锁堆栈
 */
- (void)uploadMainThreadDeadlockWithBacktrace:(NSString *)backtrace;

@end

@interface TBCrashReporter : NSObject

@property (nonatomic, assign) id<TBCrashReporterDelegate> delegate;

+ (instancetype)sharedReporter;

/**
 *  初始化
 */
- (void)initCrashSDKWithAppVersion:(NSString*)appVersion;

/**
 * 关闭crashreporter
 */
- (void)turnOffCrashReporter;

/**
 *  当用户更换帐号登录时，重新传递一次usernick
 */
- (void)setWhenChangeUserNick:(NSString*)usernick;

/**
 *  当用户更换appVersion的时候，重新设置appVersion
 */
- (void)setAppVersion:(NSString*)appVersion;

/**
 *  是否合并重复的crash文件，如果需要请设置为YES
 */
- (void)setMergeCrashReport:(BOOL)isMerge;

/**
 * 单独发送使用方捕获的crashreport，手淘用
 */
- (void)sendCatchedCrashReportWithContent:(NSString*)content;

/**
 * 设置TBCrashReporter的捕获方式为mach exception，输入参数设置为YES,该接口调用需在initCrashSDK之前。该模式能一定程度的增加crash的捕获率，如死锁等，但对于ios平台仍然不太完善，接入方慎用该模式。
 */
- (void)setCrashReporterModuleToMachException:(BOOL)isMachException;

/**
 *  使用方调用该接口检查是否有crash文件，有的话则会实现上传，调用时机可由使用方自己决定
 * （建议不要在启动时调用，可在其他时机调用，如应用切后台时调用等）
 */
- (void)checkAndUploadCrashReporter;

/**
 *  开始主线程死锁监控, 需要在initCrashSDK之后调用
 */
- (void)turnOnMainThreadDeadlockMonitor;

/**
 *  开启主线程监控并设置死锁时间周期, 需要在initCrashSDK之后调用
 *
 *  @param deadlockInterval 死锁时间周期（PS：这个值设小了会把有些正常人物误认为死锁，设大了在检测到死锁时用户可能强退导致不能上报数据，默认为5s）
 */
- (void)turnOnMainThreadDeadlockMonitorWithDealockInterval:(NSTimeInterval)deadlockInterval;

/**
 *  关闭
 */
- (void)turnOffMainThreadDeadlockMonitor;

@end
