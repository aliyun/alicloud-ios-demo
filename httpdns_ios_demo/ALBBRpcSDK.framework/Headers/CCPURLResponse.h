//
//  CCPURLResponse.h
//  CloudPush
//
//  Created by wuxiang on 14-8-14.
//  Copyright (c) 2014年 ___alibaba___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCPURLResponse : NSObject



@property (nonatomic, strong) NSData              *data;
@property (nonatomic, strong) NSData              *serviceResult; // rpc请求后返回来的二进制结果
@property (nonatomic, strong) NSMutableDictionary *responseHeaders;
@property (nonatomic        ) UInt8               contentType;// 序列化的类型（0：原始数据）
@property (nonatomic        ) NSInteger           serviceStatusCode;// 序列化的类型（0：原始数据）
@property (nonatomic, strong) NSString            *invokeWay; // 执行方式

@property (nonatomic, strong) NSString  *responseJsonResult; // rpc请求回来后的json结果

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

-(id) initWithInvokeWay:(NSString *) invokeWay;

-(NSData *) memberOfData:(NSData *)object ;


-(NSString *) getResponseJson;

@end
