//
//  HttpDNSOrigin.h
//  httpdns_api_demo
//
//  Created by nanpo.yhl on 15/10/29.
//  Copyright © 2015年 com.aliyun.mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpDNSOrigin : NSObject
@property(nonatomic, copy, readonly) NSString* host;
@property(nonatomic, strong) NSArray* ips;
@property(nonatomic,assign) long ttl;
@property(nonatomic,assign) long query;

-(id)initWithHost:(NSString*)host;

-(BOOL)isExpired;

-(NSString*)getIp;

-(NSArray*)getIps;

@end
