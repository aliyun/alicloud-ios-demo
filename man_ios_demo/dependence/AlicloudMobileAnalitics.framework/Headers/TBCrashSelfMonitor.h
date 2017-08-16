//
//  TBCrashSelfMonitor.h
//  TBCrashReporter
//
//  Created by qiulibin on 15/10/22.
//  Copyright © 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBCrashSelfMonitor : NSObject<NSCoding>

@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *userNick;
@property (nonatomic, strong) NSString *sendFlag;
@property (nonatomic, strong) NSString *crashTimes;  //crash次数，去重用
@property (nonatomic, strong) NSString* hashCode;


/**
 * only one instance
 */
+(instancetype)shareInstance;

@end
