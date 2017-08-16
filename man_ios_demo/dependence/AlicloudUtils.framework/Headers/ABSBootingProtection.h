//
//  ABSBootingProtection.h
//  AntilockBrakeSystem
//
//  Created by 地风（ElonChan） on 16/5/16.
//  Copyright © 2016年 Ali. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ABSBoolCompletionHandler)(BOOL succeeded, NSError *error);
typedef void (^ABSRepairBlock)(ABSBoolCompletionHandler completionHandler);
typedef void (^ABSReportBlock)(NSUInteger crashCounts);

typedef NS_ENUM(NSInteger, ABSBootingProtectionStatus) {
    ABSBootingProtectionStatusNormal,  /**<  APP 启动正常 */
    ABSBootingProtectionStatusNormalChecking,  /**< 正在检测是否会在特定时间内是否会 Crash，注意：检测状态下“连续启动崩溃计数”个数小于或等于上限值 */
    ABSBootingProtectionStatusNeedFix, /**< APP 出现连续启动 Crash，需要采取修复措施 */
    ABSBootingProtectionStatusFixing,   /**< APP 出现连续启动 Crash，正在修复中... */
};

/**
 * 启动连续 crash 保护。
 * 启动后 `_crashOnLaunchTimeIntervalThreshold` 秒内 crash，反复超过 `_continuousCrashOnLaunchNeedToReport` 次则上报日志，超过 `_continuousCrashOnLaunchNeedToFix` 则启动修复操作。
 */
@interface ABSBootingProtection : NSObject

/**
 * 启动连续 crash 保护方法。
 * 前置条件：在 App 启动时注册 crash 处理函数，在 crash 时调用[ABSBootingProtection addCrashCountIfNeeded]。
 * 启动后一定时间内（`crashOnLaunchTimeIntervalThreshold`秒内）crash，反复超过一定次数（`continuousCrashOnLaunchNeedToReport`次）则上报日志，超过一定次数（`continuousCrashOnLaunchNeedToFix`次）则启动修复程序；在一定时间内（`crashOnLaunchTimeIntervalThreshold`秒） 秒后若没有 crash 将“连续启动崩溃计数”计数置零。
  `reportBlock` 上报逻辑，
  `repairtBlock` 修复逻辑，完成后执行 `[self setCrashCount:0]`

 */
- (void)launchContinuousCrashProtect;

/*!
 * 当前启动Crash的状态
 */
@property (nonatomic, assign, readonly) ABSBootingProtectionStatus bootingProtectionStatus;

/*!
 * 达到需要执行上报操作的“连续启动崩溃计数”个数。
 */
@property (nonatomic, assign, readonly) NSUInteger continuousCrashOnLaunchNeedToReport;

/*!
 * 达到需要执行修复操作的“连续启动崩溃计数”个数。
 */
@property (nonatomic, assign, readonly) NSUInteger continuousCrashOnLaunchNeedToFix;

/*!
 * APP 启动后经过多少秒，可以将“连续启动崩溃计数”清零
 */
@property (nonatomic, assign, readonly) NSTimeInterval crashOnLaunchTimeIntervalThreshold;

/*!
 * 借助 context 可以让多个模块注册事件，并且事件 block 能独立执行，互不干扰。
 */
@property (nonatomic, copy, readonly) NSString *context;

/*!
 * @details 启动后kCrashOnLaunchTimeIntervalThreshold秒内crash，反复超过continuousCrashOnLaunchNeedToReport次则上报日志，超过continuousCrashOnLaunchNeedToFix则启动修复程序；当所有操作完成后，执行 completion。在 crashOnLaunchTimeIntervalThreshold 秒后若没有 crash 将 kContinuousCrashOnLaunchCounterKey 计数置零。
 * @param context 借助 context 可以让多个模块注册事件，并且事件 block 能独立执行，互不干扰。
 */
- (instancetype)initWithContinuousCrashOnLaunchNeedToReport:(NSUInteger)continuousCrashOnLaunchNeedToReport
                           continuousCrashOnLaunchNeedToFix:(NSUInteger)continuousCrashOnLaunchNeedToFix
                         crashOnLaunchTimeIntervalThreshold:(NSTimeInterval)crashOnLaunchTimeIntervalThreshold
                                                    context:(NSString *)context;
/*!
 * 当前“连续启动崩溃“的状态
 */
+ (ABSBootingProtectionStatus)bootingProtectionStatusWithContext:(NSString *)context continuousCrashOnLaunchNeedToFix:(NSUInteger)continuousCrashOnLaunchNeedToFix;

/*!
 * 设置上报逻辑，参数 crashCounts 为启动连续 crash 次数
 */
- (void)setReportBlock:(ABSReportBlock)reportBlock;

/*!
 * 设置修复逻辑
 */
- (void)setRepairBlock:(ABSRepairBlock)repairtBlock;

@end
