//
//  ABSUncaughtExceptionHandler.h
//  AntilockBrakeSystem
//
//  Created by 地风（ElonChan） on 16/5/16.
//  Copyright © 2016年 Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ABSUncaughtExceptionCallback)(NSException *exception);

@interface ABSUncaughtExceptionHandler : NSObject

+ (void)registerExceptionHandlerWithCallback:(ABSUncaughtExceptionCallback)callback;

@end
