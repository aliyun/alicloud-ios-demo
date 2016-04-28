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

@property (nonatomic, strong) NSDictionary *params;

/**
 *  设置方法
 *
 *  @param method
 */
-(void) setHTTPMethod:(NSString *) method;

-(void) setParams:(NSDictionary *)params;

-(void) setTimeout:(NSTimeInterval)timeout;

-(void) setResource:(NSString *)resource;

-(void) setResouceType:(UInt8)resouceType;

-(void) setContentType:(UInt8)contentType;

-(void) setCallerVersion:(NSString *)callerVersion;

-(void) setCodecKey:(NSString *)codecKey;

-(void) setPlatformId:(NSString *)platformId;

-(NSData *) encryptRequestData:(BOOL) needEncrypt;

@end
