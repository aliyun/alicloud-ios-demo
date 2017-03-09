//
//  CloudPushSDK.h
//  CloudPushSDK
//
//  Created by junmo on 16/7/26.
//  Copyright © 2016年 aliyun.mobileService. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCPSysMessage.h"
#import "MPGerneralDefinition.h"

#define MPUSH_IOS_SDK_VERSION @"1.9.1"

@interface CloudPushSDK : NSObject

/**
 *	Push SDK初始化
 *
 *	@param 	appKey          appKey
 *	@param 	appSecret       appSecret
 *	@param 	callback        回调
 */
+ (void)asyncInit:(NSString *)appKey
        appSecret:(NSString *)appSecret
         callback:(CallbackHandler)callback;

/**
 *	打开调试日志
 */
+ (void)turnOnDebug;

/**
 *	获取本机的deviceId (以设备为粒度推送时，deviceId为设备的标识)
 *
 *	@return deviceId
 */
+ (NSString *)getDeviceId;

/**
 *	返回SDK版本
 *
 *	@return SDK版本
 */
+ (NSString *)getVersion;

/**
 *	返回推送通道的状态
 *
 *	@return 通道状态
 */
+ (BOOL)isChannelOpened;

/**
 *	返回推送通知ACK到服务器
 *
 *	@param 	userInfo   通知相关信息
 */
+ (void)sendNotificationAck:(NSDictionary *)userInfo;

/**
 *	返回推送通知ACK到服务器 (该通知为App处于关闭状态时接收，点击后启动App)
 *	v1.8.1版本之后，由sendNotificationAck替代
 *	@param 	launchOptions   通知相关信息
 */
+ (void)handleLaunching:(NSDictionary *)launchOptions;

/**
 *	返回推送通知ACK到服务器 (该通知为App处于开启状态时接收)
 *	v1.8.1版本之后，由sendNotificationAck替代
 *	@param 	userInfo    通知相关信息
 */
+ (void)handleReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 *	绑定账号
 *
 *	@param 	account     账号名
 *	@param 	callback    回调
 */
+ (void)bindAccount:(NSString *)account
       withCallback:(CallbackHandler)callback;

/**
 *	解绑账号
 *
 *	@param 	callback    回调
 */
+ (void)unbindAccount:(CallbackHandler)callback;

/**
 *	向指定目标添加自定义标签
 *	支持向本设备/本设备绑定账号/别名添加自定义标签，目标类型由target指定
 *	@param 	target      目标类型，1：本设备  2：本设备绑定账号  3：别名
 *	@param 	tags        标签名
 *	@param 	alias       别名（仅当target = 3时生效）
 *	@param 	callback 	回调
 */
+ (void)bindTag:(int)target
       withTags:(NSArray *)tags
      withAlias:(NSString *)alias
   withCallback:(CallbackHandler)callback;

/**
 *	删除指定目标的自定义标签
 *	支持从本设备/本设备绑定账号/别名删除自定义标签，目标类型由target指定
 *	@param 	target      目标类型，1：本设备  2：本设备绑定账号  3：别名
 *	@param 	tags        标签名
 *	@param 	alias       别名（仅当target = 3时生效）
 *	@param 	callback 	回调
 */
+ (void)unbindTag:(int)target
         withTags:(NSArray *)tags
        withAlias:(NSString *)alias
     withCallback:(CallbackHandler)callback;

/**
 *  查询绑定标签，查询结果可从callback的data中获取
 *
 *  @param target       目标类型，1：本设备（当前仅支持查询本设备绑定标签）
 *  @param callback     回调
 */
+ (void)listTags:(int)target
    withCallback:(CallbackHandler)callback;

/**
 *	给当前设备打别名
 *
 *	@param 	alias       别名名称
 *	@param 	callback 	回调
 */
+ (void)addAlias:(NSString *)alias
    withCallback:(CallbackHandler)callback;

/**
 *	删除当前设备的指定别名
 *  当alias为nil or length = 0时，删除当前设备绑定所有别名
 *	@param 	alias       别名名称
 *	@param 	callback 	回调
 */
+ (void)removeAlias:(NSString *)alias
       withCallback:(CallbackHandler)callback;

/**
 *  查询本设备绑定别名，查询结果可从callback的data中获取
 *
 *  @param callback     回调
 */
+ (void)listAliases:(CallbackHandler)callback;

/**
 *  向阿里云推送注册该设备的deviceToken
 *
 *  @param deviceToken 苹果APNs服务器返回的deviceToken
 */
+ (void)registerDevice:(NSData *)deviceToken
          withCallback:(CallbackHandler)callback;

/**
 *	获取APNs返回的deviceToken
 *
 *	@return deviceToken
 */
+ (NSString *)getApnsDeviceToken;

@end
