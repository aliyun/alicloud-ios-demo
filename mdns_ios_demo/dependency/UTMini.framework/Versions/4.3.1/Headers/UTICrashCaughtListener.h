//
//  UTICrashCaughtListener.h
//  miniUTInterface
//
//  Created by 宋军 on 14/10/28.
//  Copyright (c) 2014年 ___SONGJUN___. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UTICrashCaughtListener <NSObject>

-(NSDictionary *) onCrashCaught:(NSString *) pCrashReason CallStack:(NSString *)callStack;

@end
