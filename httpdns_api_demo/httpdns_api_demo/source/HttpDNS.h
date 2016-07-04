//
//  HttpDNS.h
//  httpdns_api_demo
//
//  Created by nanpo.yhl on 15/10/29.
//  Copyright © 2015年 com.aliyun.mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDNSDegradationDelegate.h"

@class HttpDNSOrigin;

@interface HttpDNS : NSObject

+(HttpDNS*)instance;


/*
 *   超时域名是否还生效接口
 *
 */
-(void)setExpiredIpAvailable:(BOOL)flags;

-(BOOL)isExpiredIpAvailable;

/*
 * 获取一个IP
 */
-(NSString*)getIpByHost:(NSString*)host;


/*
 * 获取多个IP的接口 NSArray
 * 里面都是NSString的类型IP地址
 */
-(NSArray*)getIpsByHost:(NSString*)host;

@property (nonatomic, weak) id<HttpDNSDegradationDelegate> delegate;

-(void)setDelegateForDegradationFilter:(id<HttpDNSDegradationDelegate>)delegate;

@end
