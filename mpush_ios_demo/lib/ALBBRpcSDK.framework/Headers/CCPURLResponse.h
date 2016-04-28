//
//  CCPURLResponse.h
//  CloudPush
//
//  Created by wuxiang on 14-8-14.
//  Copyright (c) 2014年 ___alibaba___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCPURLResponse : NSObject

/**
 rpc 错误码
 */
enum {
    RPC_ERROR_CHANNEL_NOT_READY           = 0,
    RPC_ERROR_CHANNEL_SID_INVLID          = 1,
    RPC_ERROR_CHANNEL_RPC_TIMEOUT         = 3,
    RPC_ERROR_CHANNEL_HTTP_ERROR          = 4,
    RPC_ERROR_CHANNEL_DECODE_ERROR        = -1,
    RPC_ERROR_CHANNEL_SERVICE_NOT_FOUND   = 404,
    RPC_ERROR_CHANNEL_SERVICE_GATEWAY_BAD = 500,
    RPC_ERROR_CHANNEL_SERVICE_UNAVAILABLE = 503,
    RPC_ERROR_CHANNEL_SERVICE_TIMEOUT     = 504,

    
};

@property (nonatomic, strong) NSData              *data;
@property (nonatomic, strong) NSData              *serviceResult;
@property (nonatomic, strong) NSMutableDictionary *responseHeaders;
@property (nonatomic        ) UInt8               contentType;// 序列化的类型（0：原始数据）
@property (nonatomic        ) NSInteger           serviceStatusCode;// 序列化的类型（0：原始数据）

@property (nonatomic, strong) NSString  *responseJsonResult;

/**
 *  初始化数据
 *
 *  @param nsdata
 *  @param needDecrypt
 *
 *  @return
 */
-(id) initWithData: (NSData *) nsdata : (BOOL) needDecrypt ;

-(id) initWithData: (NSData *) nsdata : (BOOL) needDecrypt :(NSString *) decryptKey;

-(NSData *) memberOfData:(NSData *)object ;

-(void) setData:(NSData *)data ;


-(NSString *) getResponseJson;

@end
