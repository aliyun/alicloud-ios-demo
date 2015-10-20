//
//  ALBBRpcSDK.h
//  ALBBRpcSDK
//
//  Created by wuxiang on 15/4/21.
//  Copyright (c) 2015年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCPURLRequest.h"
#import "CCPRequestOperation.h"

#define ALBB_RPC_VERSION 1.4.7

typedef enum{
    ALBBRpcSDKEnvironmentDaily,  //测试环境
    ALBBRpcSDKEnvironmentPre,//预发环境
    ALBBRpcSDKEnvironmentSandBox,// 沙箱环境
    ALBBRpcSDKEnvironmentRelease//线上环境
} ALBBRpcSDKEnvironmentEnum;


/**
 rpc 错误码
 */
typedef enum {
    RPC_ERROR_CHANNEL_PARAM_ILLEGAL       = -1,
    RPC_ERROR_CHANNEL_NOT_READY           = 0,
    RPC_ERROR_CHANNEL_SID_INAVLID          = 1,
    RPC_ERROR_CHANNEL_RPC_TIMEOUT         = 3,
    RPC_ERROR_CHANNEL_HTTP_ERROR          = 4,
    RPC_ERROR_CHANNEL_DECODE_ERROR        = -2,
    RPC_ERROR_CHANNEL_SERVICE_NOT_FOUND   = 404,
    RPC_ERROR_CHANNEL_SERVICE_GATEWAY_BAD = 500,
    RPC_ERROR_CHANNEL_SERVICE_UNAVAILABLE = 503,
    RPC_ERROR_CHANNEL_SERVICE_TIMEOUT     = 504,
    
    
} RPC_ERROR_CHANNEL_ENUM;


@interface ALBBRpcSDK : NSObject


+ (void) setEnvironment: (ALBBRpcSDKEnvironmentEnum) env;

/**
 * 智能模式，有tcp时，会自动走tcp,默认http
 */
+(void) executeRequest:(CCPURLRequest *) ccpRequest
              success :(successCallBack) successCallBack
               failure:(failureCallBack) failureCallBack
               timeout:(NSTimeInterval) timeout;


/**
 *  http
 *
 *  @param ccpRequest
 *  @param successCallBack
 *  @param failureCallBack
 */
+(void) executeHttpRequest:(CCPURLRequest *) ccpRequest
                  success :(successCallBack) successCallBack
                   failure: (failureCallBack)failureCallBack
                   timeout:(NSTimeInterval) timeout;


+(NSString *) getVersion;

@end
