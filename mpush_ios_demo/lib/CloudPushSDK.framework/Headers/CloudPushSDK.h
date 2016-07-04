//
//  CloudPushSDK.h
//  CloudPushSDK
//
//  Created by wuxiang on 14-8-27.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "CloudPushCallbackResult.h"
#import <Foundation/Foundation.h>

#define CLOUDPUSH_IOS_SDK_VERSION   @"1.6.0"

typedef enum{
    CCPSDKEnvironmentDaily,     // 测试环境
    CCPSDKEnvironmentPre,       // 预发环境
    CCPSDKEnvironmentSandBox,   // 沙箱环境
    CCPSDKEnvironmentRelease    // 线上环境
} CCPSDKEnvironmentEnum;

typedef void (^CallbackHandler)(CloudPushCallbackResult *res);

@protocol CloudPushSDKServiceDelegate <NSObject>

- (void)messageReceived:(NSData*)content msgId:(NSInteger)msgId;

@end

@interface CloudPushSDK : NSObject<CloudPushSDKServiceDelegate>

@property (strong, nonatomic) id<CloudPushSDKServiceDelegate> delegate;

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
 *	@return
 */
+ (NSString *)getDeviceId;

/**
 *	返回SDK版本
 *
 *	@return
 */
+ (NSString *)getVersion;

/**
 *	返回推送通道的状态
 *
 *	@return
 */
+ (BOOL)isChannelOpened;

/**
 *	返回推送通知ACK到服务器 (该通知为App处于关闭状态时接收，点击后启动App)
 *
 *	@param 	launchOptions 	
 */
+ (void)handleLaunching:(NSDictionary *)launchOptions;

/**
 *	返回推送通知ACK到服务器 (该通知为App处于开启状态时接收)
 *
 *	@param 	userInfo 	
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
 *	设置消息可接收的时间，比如08：00 --- 23：00
 *
 *	@param 	startH      起始小时
 *	@param 	startMS     起始分钟
 *	@param 	endH        结束小时
 *	@param 	endMS       结束分钟
 *	@param 	callback 	回调
 */
+ (void)setAcceptTime:(UInt32)startH
              startMS:(UInt32)startMS
                 endH:(UInt32)endH
                endMS:(UInt32)endMS
         withCallback:(CallbackHandler)callback;

/**
 *  增加自定义的tag, 目前只支持12个自定义的tag
 *
 *  @param tag      tag
 *  @param callback 回调
 */
+ (void)addTag:(NSString *)tag withCallback:(CallbackHandler)callback;

/**
 *  删除自定义的tag, 目前只支持12个自定义的tag
 *
 *  @param tag      tag
 *  @param callback 回调
 */
+ (void)removeTag:(NSString *)tag withCallback:(CallbackHandler)callback;

/**
 *	获取APNs返回的deviceToken
 *
 *	@return
 */
+ (NSString *)getApnsDeviceToken;

/**
 *  向阿里云推送注册该设备的deviceToken，用户推送通知
 *
 *  @param  deviceToken 苹果APNs服务器推送下来的deviceToken
 *
 *  @return
 */
+ (void)registerDevice:(NSData *)deviceToken;

/**
 *	Json转换方法 (建议用户不要使用)
 *
 *	@param 	dict
 *
 *	@return
 */
+ (NSString *)toJson:(NSDictionary * )dict;

/**
 *	设置环境变量 (用户不要调用)
 *
 *	@param 	env
 */
+ (void)setEnvironment:(CCPSDKEnvironmentEnum)env;

@end
