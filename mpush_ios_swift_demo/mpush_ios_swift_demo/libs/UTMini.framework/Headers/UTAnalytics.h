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


+ (void) turnOnDev2;

/**
 *  单例初始化时，不再会从安全图片和指令plist读取appkey
 *
 *  @return 返回UTAnalytics单例
 *
 */
+(UTAnalytics *) getInstance;


/**
 *  老接口兼容:接口方式设置主app级appkey/appsecret对
 *           重复设置抛异常
 *
 *  @param appKey 主app级的appkey
 *
 *  @param secret 主app级的appsecret
 *
 */
- (void)setAppKey:(NSString *)appKey secret:(NSString *)secret;


/**
 *  新接口1:从安全图片读取出appkey后，塞給ut，作为主app级的appkey
 *         重复设置抛异常
 *
 *  @param appKey 主app级的appkey
 *
 *  @param authocode 多图片时的后缀;为nil时，对应默认图片
 *
 */
- (void)setAppKey4APP:(NSString *)appKey authcode:(NSString *)authcode;


/**
 *  新接口2:接口方式设置SDK级appkey/appsecret对
 *         !!!请注意：只设置了SDK级appkey，埋点方法(UTTracker *) getTracker:(NSString *)  pTrackId将不起作用
 *         !!!请注意：一定要先设置了主app级appkey，埋点方法(UTTracker *) getTracker:(NSString *)  pTrackId才会作用
 *
 *  @param appKey SDK级的appkey
 *
 *  @param secret SDK级的appsecret
 *
 */
- (void)setAppKey4SDK:(NSString *)appKey secret:(NSString *)secret;


/**
 *  新接口3:从安全图片读取出appkey后，塞給ut，作为SDK级的appkey
 *         !!!请注意：只设置了SDK级appkey，埋点方法(UTTracker *) getTracker:(NSString *)  pTrackId将不起作用
 *         !!!请注意：一定要先设置了主app级appkey，埋点方法(UTTracker *) getTracker:(NSString *)  pTrackId才会作用
 *
 *  @param appKey SDK级的appkey
 *
 *  @param authocode 多图片时的后缀;为nil时，对应默认图片
 *
 */
- (void)setAppKey4SDK:(NSString *)appKey authcode:(NSString *)authcode;


+ (void)setDailyEnvironment  __deprecated;

/**
 *  老接口:对主app级的appkey设置appversion
 *
 *  @param pAppVersion app级的appversion
 *
 */
-(void) setAppVersion:(NSString *) pAppVersion;


-(void) setChannel:(NSString *) pChannel;

-(void) updateUserAccount:(NSString *) pNick userid:(NSString *) pUserId;

-(void) userRegister:(NSString *) pUsernick;

-(void) updateSessionProperties:(NSDictionary *) pDict;


/**
 *  老接口兼容:获取默认的UTTracker.
 *           如果设置了app级的appkey,默认的tracker对应app级的生产者
 *           如果只设置了sdk级的appkey，默认的tracker为空,返回第一个设置appkey的对应生产者
 *
 *  @return 默认的UTTracker
 *
 */
-(UTTracker *) getDefaultTracker;


/**
 *  老接口兼容:返回trackid对应的UTTracker.
 *           只能已经设置主app级appkey的前提下，才能有效设置并返回
 *
 *  @param pTrackId 主app级的trackid
 *
 *  @return 返回trackid对应的UTTracker
 *
 */
-(UTTracker *) getTracker:(NSString *)  pTrackId;


/**
 *  新接口:获取sdk级对应的UTTracker.
 *        只有已经设置对应的sdk级的appkey的前提下，才能有效返回
 *
 *  @param pAppkey SDK级的appkey
 *
 *  @return sdk级对应的UTTracker
 *
 */
-(UTTracker *) getTracker4SDK:(NSString *) pAppkey;

-(void) turnOnDebug;

-(void) turnOnDev;

// 以下接口功能已废弃，接口保留
-(void) setRequestAuthentication:(id<UTIRequestAuthentication>) pRequestAuth __deprecated;

- (void)onCrashHandler;

-(void) turnOffCrashHandler;

-(void) setCrashCaughtListener:(id<UTICrashCaughtListener>) aListener;

@end
