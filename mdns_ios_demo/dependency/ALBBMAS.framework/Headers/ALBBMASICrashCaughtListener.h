//
//  ALBBMASICrashCaughtListener.h
//  TestMAS
//
//  Created by 郭天 on 15/3/5.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UTMini/UTICrashCaughtListener.h>

@protocol ALBBMASICrashCaughtListener <UTICrashCaughtListener>

-(NSDictionary *) onCrashCaught:(NSString *) pCrashReason CallStack:(NSString *)callStack;

@end
