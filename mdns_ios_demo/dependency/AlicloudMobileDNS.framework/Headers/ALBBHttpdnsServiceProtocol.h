//
//  ALBBHttpdnsServiceProtocol.h
//  ALBBHttpdnsSDK
//
//  Created by zhouzhuo on 7/7/15.
//  Copyright (c) 2015 zhouzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ALBBHttpdnsServiceProtocol <NSObject>

-(void)setAppId:(NSString *)appId;

-(void)setCredentialProvider:(id)credential;

// 添加预解析域名
-(void)setPreResolveHosts:(NSArray *)hosts;

// 根据域名同步查询ip，阻塞
-(NSString *)getIpByHost:(NSString *)host;

// 根据域名异步查询ip，非阻塞
-(NSString *)getIpByHostAsync:(NSString *)host;

@end
