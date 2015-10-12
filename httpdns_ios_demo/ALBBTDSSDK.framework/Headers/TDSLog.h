//
//  TDSLog.h
//  TestTDS
//
//  Created by 郭天 on 15/5/12.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>

extern BOOL isEnableTDSLog;

@interface TDSLog : NSObject

+ (void)enableLog:(BOOL)isEnbale;
+ (void)LogD:(NSString *)format, ...;
+ (void)LogE:(NSString *)format, ...;

@end
