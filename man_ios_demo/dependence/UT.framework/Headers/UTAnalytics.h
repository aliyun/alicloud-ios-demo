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

-(void) setAppVersion:(NSString *) pAppVersion;

-(void) setChannel:(NSString *) pChannel;

-(void) updateUserAccount:(NSString *) pNick userid:(NSString *) pUserId;

-(void) userRegister:(NSString *) pUsernick;

-(void) updateSessionProperties:(NSDictionary *) pDict;

-(UTTracker *) getDefaultTracker;

-(UTTracker *) getTracker:(NSString *)  pTrackId;

-(void) setRequestAuthentication:(id<UTIRequestAuthentication> ) pRequestAuth;

-(void) turnOnDebug;

-(void) turnOnDev;

-(void) turnOffCrashHandler;

-(void) setCrashCaughtListener:(id<UTICrashCaughtListener>) aListener;

+(NSString *) utsid;

/*
 *功能：改变切后台sessionid改变的时间间隔
 *注意：a.只有在白名单内的appkey，调这个接口才会起作用;要加入该白名单，要跟ut方面协商
 *     b.interval:单位为秒;最短时间不能低于30秒
 */
- (void) setSessionTimeOut:(NSUInteger) interval;

@end
