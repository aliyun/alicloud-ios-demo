//
//  ALBBOneSDK.h
//  ALBBOneSDK
//
//  Created by 友和 on 15/4/1.
//  Copyright (c) 2015年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALBB_SDK_VERSION  @"1.1.0"

typedef void (^initSuccessCallback)();
typedef void (^initFailedCallback)(NSError *error);

@interface ALBBSDK : NSObject


+ (instancetype) sharedInstance ;


#pragma -mark SDK 环境定义

typedef enum{
    ALBBSDKEnvironmentDaily,  //测试环境
    ALBBSDKEnvironmentPreRelease,//预发环境
    ALBBSDKEnvironmentRelease,//线上环境
    ALBBSDKEnvironmentSandBox//沙箱环境
    
} ALBBSDKEnvironment;


ALBBSDKEnvironment currentEnvironment();//当前环境
/**
 *  设置SDK 环境信息，Tae内部测试使用
 *
 *  @param environmentType 见TaeSDKEnvironment
 */
-(void)setALBBSDKEnvironment:(ALBBSDKEnvironment) environmentType;

///**
// *  oneSDK初始化，异步执行
// *
// *  @param sucessCallback 初始化成功回调
// *  @param failedCallback 初始化失败回调
// */
//-(void)asyncInit:(initSuccessCallback) sucessCallback
//  failedCallback:(initFailedCallback) failedCallback;

/**
 *  oneSDK初始化，异步执行
 *
 *  @param sucessCallback 初始化成功回调
 *  @param failedCallback 初始化失败回调
 */
-(void)asyncInit:(NSString *) appKey
       appSecret:(NSString *) appSecret :
       (initSuccessCallback) sucessCallback
     failedCallback:(initFailedCallback) failedCallback;

-(NSString *) getVersion;


#pragma -mark SDK 业务开关

/**
 *  打开debug日志
 *
 *  @param isDebugLogOpen
 */
-(void) setDebugLogOpen:(BOOL) isDebugLogOpen;

/**
 *  关闭TAE设置的crashHandler
 */
-(void) closeCrashHandler;


/**
 *  获取TAESDK以及所有插件SDK暴露的service 实例
 *
 *  @param protocol service的协议
 *
 *  @return service实例
 */
-(id) getService:(NSString *)serviceName
        protocol:(Protocol *)protocol;

@end

