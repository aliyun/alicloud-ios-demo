//
//  CCPURLRequest.h
//  CloudPush
//
//  Created by wuxiang on 14-8-14.
//  Copyright (c) 2014年 ___alibaba___. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  发起请求的一方
 */
@interface CCPURLRequest : NSObject

@property (nonatomic, strong) NSString            *domain;
@property (nonatomic, strong) NSString            *sid;// 会话标识
@property (nonatomic, strong) NSString            *resource;// 资源唯一标识
@property (nonatomic, strong) NSString            *method;
@property (nonatomic        ) NSTimeInterval      timeout;
@property (nonatomic, strong) NSString            *version;
@property (nonatomic, strong) NSString            *callerVersion;
@property (nonatomic, strong) NSString            *codecKey;// 加解密的key
@property (nonatomic        ) UInt8               contentType;// 序列化的类型（0：原始数据）
@property (nonatomic        ) UInt8               resouceType;
@property (nonatomic, strong) NSString            *platformId;
@property (nonatomic, strong) NSMutableDictionary *heads;// http header
@property (nonatomic, strong) NSDictionary        *params;
@property (nonatomic, strong) NSData              *customBody;
@property (nonatomic, strong) NSString            *gatewayUrl;// 自定义url
@property (nonatomic        ) UInt8                apiType; // 1为云通道自己的API，2为二方的API，3为三方的API

-(NSData *) encryptRequestData:(BOOL) needEncrypt;

@end
