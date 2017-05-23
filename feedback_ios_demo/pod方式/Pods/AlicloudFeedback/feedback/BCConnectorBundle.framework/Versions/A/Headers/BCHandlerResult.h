//
//  WQHandlerResult.h
//  WQOpenSDK
//
//  Created by qinghua.liqh on 14-2-26.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WQHandlerResult BCHandlerResult

typedef enum _WQHandlerResultCode{
    WQHandlerResultCodeOK = 0,
    WQHandlerResultCodeError = 1,
    WQHandlerResultCodeCancel = 2,
    WQHandlerResultCodeTimeOut = 3,
    WQHandlerResultCodeArgErr = 4,      // 参数错误
    WQHandlerResultCodeException = 5,   // 异常退出
    WQHandlerResultCodeUserDefined = 6, // 用户自定义
    WQHandlerResultCodeUnSupportted = 7 // 不支持
}WQHandlerResultCode;


@interface WQHandlerResult : NSObject
@property (strong, nonatomic) NSString *strCode;                    //用户自定义code
@property (assign, nonatomic) WQHandlerResultCode retCode;          //调用成功返回码
@property (strong, nonatomic) NSDictionary *retResult;              //业务返回数据

+ (id)resultFromCode:(WQHandlerResultCode)code result:(NSDictionary *)result strCode:(NSString *)strCode;
+ (id)resultFromCode:(WQHandlerResultCode)code result:(NSDictionary *)result;
+ (id)resultFromCode:(WQHandlerResultCode)code;
@end
