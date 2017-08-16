//
//  TBCrashViewControllerInfo.h
//  TBCrashReporter
//
//  Created by qlb on 15/4/13.
//  Copyright (c) 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CrashViewControllerInfoDelegate <NSObject>

@optional
/**
 *  数据上报时获取ViewControler
 *
 *  @return ViewControler name
 */
- (NSString *)crashReporterViewControlerInfo;

@end


@interface TBCrashViewControllerInfo : NSObject

+ (instancetype)sharedInstance;

/**
 *  额外信息拉取
 *
 *  @return ViewController信息
 */
- (NSString *)crashReportCallBackViewControllerInfo;

/**
 *  注册返回ViewControlle的r对象
 *
 */
- (void)registerCrashViewControllerInfo:(id<CrashViewControllerInfoDelegate>)viewControlInfo;

@end
