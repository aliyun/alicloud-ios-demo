//
//  ALBBMASAnalytics.h
//  TestMAS
//
//  Created by 郭天 on 15/3/4.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UTMini/UTAnalytics.h>
//#import "UTAnalytics.h"
#import "ALBBMASTracker.h"
#import "ALBBMASIRequestAuthentication.h"
#import "ALBBMASICrashCaughtListener.h"

@interface ALBBMASAnalytics : NSObject

+ (ALBBMASAnalytics *) getInstance;

- (void)initWithAppKey:(NSString *)appKey secretKey:(NSString *)secretKey;

- (void)initWithAppKey:(NSString *)appKey;

- (void)updateUserAccount:(NSString *) pNick userid:(NSString *) pUserId;

- (void)userRegister:(NSString *) pUsernick;

- (ALBBMASTracker *)getDefaultTracker;

- (ALBBMASTracker *)getTracker:(NSString *)  pTrackId;

- (void)setRequestAuthentication:(id<ALBBMASIRequestAuthentication> ) pRequestAuth;

- (void)turnOffCrashHandler;

- (void)setCrashCaughtListener:(id<ALBBMASICrashCaughtListener>) aListener;

@end
