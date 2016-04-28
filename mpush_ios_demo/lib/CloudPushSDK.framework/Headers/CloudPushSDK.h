//
//  CloudPushSDK.h
//  CloudPushSDK
//
//  Created by wuxiang on 14-8-27.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CLOUDPUSH_IOS_SDK_VERSION   @"1.4.2"

typedef enum{
    CCPSDKEnvironmentDaily,  //测试环境
    CCPSDKEnvironmentPre,//预发环境
    CCPSDKEnvironmentSandBox,// 沙箱环境
    CCPSDKEnvironmentRelease//线上环境
} CCPSDKEnvironmentEnum;


typedef void (^CCPOperateResult)(BOOL success);
typedef void (^initChannelSuccessCallback)();
typedef void (^initChannelFailCallback)(NSError *error);

@protocol CloudPushSDKServiceDelegate <NSObject>

-(void) messageReceived:(NSData*)content msgId:(NSInteger) msgId;

@end

@interface CloudPushSDK : NSObject<CloudPushSDKServiceDelegate>


@property (strong, nonatomic) id<CloudPushSDKServiceDelegate> delegate;


/**
 * 只使用云推送通道的初始化入口
 */
+(void)asyncInit:(initChannelSuccessCallback) sucessCallback
  failedCallback:(initChannelFailCallback) failedCallback account:(NSString *) account;

/**
 *  设置环境变量
 *
 *  @param env
 */
+ (void) setEnvironment: (CCPSDKEnvironmentEnum) env;


/**
 *  得到本机的deviceId
 *
 *  @return
 */
+(NSString *) getDeviceId;



/**
 * 通道是否打开
 */
-(BOOL) isChannelOpened;

/**
 *  用户通过通知打开应用，检查lanchOptions，主要用来发送统计回执
 *
 *  @param launchOptions
 */
+(void)handleLaunching:(NSDictionary *)launchOptions;


/**
 *  处理苹果anps 推送下来的消息，主要是用来统计回执
 *
 *  @param userInfo
 */
+(void)handleReceiveRemoteNotification:(NSDictionary *)userInfo;


/**
 * 设置账号
 */
+(void) bindAccount:(NSString *) account withCallback:(CCPOperateResult) callback;

/**
 *  去除账号绑定
 *
 *  @param account 账号
 */
+(void) unbindAccount: (NSString *) account withCallback:(CCPOperateResult) callback;


/**
 *  对外提供 json 序化列的方法
 *
 *  @param dict
 *
 *  @return
 */
+ (NSString *) toJson: (NSDictionary * )dict;


/**
 * 得到推送的当前版本
 **/
+(NSString *) getVersion;

/**
 * 设置消息可接收的时间，比如08：00 --- 23：00
 */
+(void) setAcceptTime:(UInt32) startH startMS:(UInt32) startMS endH:(UInt32)endH endMS: (UInt32)endMS withCallback:(CCPOperateResult) callback;

/**
 * 增加自定义的tag, 目前只支持12个自定义的tag
 */
+(void) addTag:(NSString *) tag withCallback:(CCPOperateResult) callback;


/**
 * 删除自定义的tag, 目前只支持12个自定义的tag
 */
+(void) removeTag:(NSString *) tag withCallback:(CCPOperateResult) callback;



/**
 *  获取苹果apns的deviceToken，只有证书配置正确，且用户同意的情况下，才有值
 *
 *  @param deviceToken
 *
 *  @return
 */
+(NSString *) getApnsDeviceToken;

/**
 *  向阿里云推送注册该设备的deviceToken，便于发送Push消息
 *
 *  @param deviceToken 苹果apns 服务器推送下来的 deviceToken
 *
 *  @return
 */
+(void)registerDevice:(NSData *) deviceToken;



@end
