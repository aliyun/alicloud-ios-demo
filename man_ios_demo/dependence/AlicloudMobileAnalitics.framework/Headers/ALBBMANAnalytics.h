//
//  ALBBMANAnalytics.h
//   
//
//  Created by 郭天 on 15/3/4.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UTMini/UTAnalytics.h>
#import "ALBBMANTracker.h"
#import "ALBBMANIRequestAuthentication.h"
#import "ALBBMANICrashCaughtListener.h"

@interface ALBBMANAnalytics : NSObject

+ (ALBBMANAnalytics *) getInstance;

- (void)initWithAppKey:(NSString *)appKey secretKey:(NSString *)secretKey;

- (void)initWithAppKey:(NSString *)appKey;

- (void)turnOnDebug;

- (void)setAppVersion:(NSString *) pAppVersion;

- (void)setChannel:(NSString *) pChannel;

- (void)updateUserAccount:(NSString *) pNick userid:(NSString *) pUserId;

- (void)userRegister:(NSString *) pUsernick;

- (ALBBMANTracker *)getDefaultTracker;

- (ALBBMANTracker *)getTracker:(NSString *)  pTrackId;

- (void)setRequestAuthentication:(id<ALBBMANIRequestAuthentication> ) pRequestAuth;

- (void)setCrashCaughtListener:(id<ALBBMANICrashCaughtListener>)aListener;

- (void)turnOffCrashHandler;

@end
