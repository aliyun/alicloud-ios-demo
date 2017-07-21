//
//  UTAnalytics.h
//  miniUTInterface
//
//  Created by 宋军 on 14-10-14.
//  Copyright (c) 2014年 ___SONGJUN___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTTracker.h"
#import "UTIRequestAuthentication.h"
#import "UTICrashCaughtListener.h"

@interface UTAnalytics : NSObject

+(UTAnalytics *) getInstance;

+ (void)setDailyEnvironment;

- (void)setAppKey:(NSString *)appKey secret:(NSString *)secret;

-(void) setAppVersion:(NSString *) pAppVersion;

-(void) setChannel:(NSString *) pChannel;

-(void) updateUserAccount:(NSString *) pNick userid:(NSString *) pUserId;

-(void) userRegister:(NSString *) pUsernick;

-(void) updateSessionProperties:(NSDictionary *) pDict;

-(UTTracker *) getDefaultTracker;

-(UTTracker *) getTracker:(NSString *)  pTrackId;

-(void) turnOnDebug;

-(void) turnOnDev;

// 以下接口功能已废弃，接口保留
-(void) setRequestAuthentication:(id<UTIRequestAuthentication>) pRequestAuth;

- (void)onCrashHandler;

-(void) turnOffCrashHandler;

-(void) setCrashCaughtListener:(id<UTICrashCaughtListener>) aListener;

@end
