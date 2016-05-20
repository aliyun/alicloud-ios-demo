//
//  CloudPushSDK.h
//  CloudPushSDK
//
//  Created by wuxiang on 14-8-27.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CLOUDPUSH_IOS_SDK_VERSION   @"1.5.0"

typedef enum{
    CCPSDKEnvironmentDaily,     // 测试环境
    CCPSDKEnvironmentPre,       // 预发环境
    CCPSDKEnvironmentSandBox,   // 沙箱环境
    CCPSDKEnvironmentRelease    // 线上环境
} CCPSDKEnvironmentEnum;


typedef void (^CCPOperateResult)(BOOL success);
typedef void (^initChannelSuccessCallback)();
typedef void (^initChannelFailCallback)(NSError *error);

@protocol CloudPushSDKServiceDelegate <NSObject>

- (void)messageReceived:(NSData*)content msgId:(NSInteger)msgId;

@end

@interface CloudPushSDK : NSObject<CloudPushSDKServiceDelegate>
@property (strong, nonatomic) id<CloudPushSDKServiceDelegate> delegate;

/**
 *	@brief	OneSDK插件方式初始化入口
 *
 *	@param 	sucessCallback 	成功回调
 *	@param 	failedCallback 	失败回调
 *	@param 	account         未指定account，传入nil
 */
+ (void)asyncInit:(initChannelSuccessCallback)sucessCallback
  failedCallback:(initChannelFailCallback)failedCallback
         account:(NSString *)account;

/**
 *	@brief	打开调试日志
 */
+ (void)turnOnDebug;

/**
 *	@brief	获取本机的deviceId (以设备为粒度推送时，deviceId为设备的标识)
 *
 *	@return
 */
+ (NSString *)getDeviceId;

/**
 *	@brief	返回SDK版本
 *
 *	@return
 */
+ (NSString *)getVersion;

/**
 *	@brief	返回推送通道的状态
 *
 *	@return
 */
+ (BOOL)isChannelOpened;

/**
 *	@brief	返回推送通知ACK到服务器 (该通知为App处于关闭状态时接收，点击后启动App)
 *
 *	@param 	launchOptions 	
 */
+ (void)handleLaunching:(NSDictionary *)launchOptions;

/**
 *	@brief	返回推送通知ACK到服务器 (该通知为App处于开启状态时接收)
 *
 *	@param 	userInfo 	
 */
+ (void)handleReceiveRemoteNotification:(NSDictionary *)userInfo;


/**
 *	@brief	绑定账号
 *
 *	@param 	account     账号名
 *	@param 	callback    回调
 */
+ (void)bindAccount:(NSString *)account
       withCallback:(CCPOperateResult)callback;

/**
 *	@brief	解绑账号
 *
 *	@param 	account     账号名
 *	@param 	callback    回调
 */
+ (void)unbindAccount:(NSString *)account
         withCallback:(CCPOperateResult)callback;

/**
 *	@brief	设置消息可接收的时间，比如08：00 --- 23：00
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
         withCallback:(CCPOperateResult)callback;

/**
 * 增加自定义的tag, 目前只支持12个自定义的tag
 */
+ (void)addTag:(NSString *)tag withCallback:(CCPOperateResult)callback;

/**
 * 删除自定义的tag, 目前只支持12个自定义的tag
 */
+ (void)removeTag:(NSString *)tag withCallback:(CCPOperateResult)callback;

/**
 *	@brief	获取APNs返回的deviceToken
 *
 *	@return
 */
+ (NSString *)getApnsDeviceToken;

/**
 *  @brief  向阿里云推送注册该设备的deviceToken，用户推送通知
 *
 *  @param  deviceToken 苹果APNs服务器推送下来的deviceToken
 *
 *  @return
 */
+ (void)registerDevice:(NSData *)deviceToken;

/**
 *	@brief	Json转换方法 (建议用户不要使用)
 *
 *	@param 	dict
 *
 *	@return
 */
+ (NSString *)toJson:(NSDictionary * )dict;

/**
 *	@brief	设置环境变量 (用户不要调用)
 *
 *	@param 	env
 */
+ (void)setEnvironment:(CCPSDKEnvironmentEnum)env;

@end
