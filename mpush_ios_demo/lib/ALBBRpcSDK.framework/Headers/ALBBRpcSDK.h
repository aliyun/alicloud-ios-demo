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


typedef enum{
    ALBBRpcSDKEnvironmentDaily,  //测试环境
    ALBBRpcSDKEnvironmentPre,//预发环境
    ALBBRpcSDKEnvironmentSandBox,// 沙箱环境
    ALBBRpcSDKEnvironmentRelease//线上环境
} ALBBRpcSDKEnvironmentEnum;





@interface ALBBRpcSDK : NSObject


+ (void) setEnvironment: (ALBBRpcSDKEnvironmentEnum) env;

+(void) executeRequest:(CCPURLRequest *) ccpRequest success :(successCallBack) successCallBack failure: (failureCallBack)failureCallBack timeout:(NSTimeInterval) timeout;


/**
 *  http
 *
 *  @param ccpRequest
 *  @param successCallBack
 *  @param failureCallBack
 */
+(void) executeHttpRequest:(CCPURLRequest *) ccpRequest success :(successCallBack) successCallBack failure: (failureCallBack)failureCallBack timeout:(NSTimeInterval) timeout;


+(NSString *) getVersion;

@end
