//
//  ALBBMANNetworkHitBuilder.h
//  AlicloudMobileAnalitics
//
//  Created by nanpo.yhl on 15/10/9.
//  Copyright (c) 2015年 com.aliyun.tds. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALBBMANNetworkError;

@interface ALBBMANNetworkHitBuilder : NSObject

-(instancetype)initWithHost:(NSString*)host method:(NSString*)method;

/*
 * 用户可以自行设置属性，但是不要包含“/Host/Method/EVENTID/PAGE/ARG1/ARG2/ARG3/ARGS/COMPRESS”
 */
- (void)setProperty:(NSString *) pKey value:(NSString *) pValue;

-(void)setproperties:(NSMutableDictionary *)properties;

/*
 * 请求开始的点
 */
-(void)requestStart;


-(void)connectFinished;


-(void)requestFirstBytes;


-(void)requestEndWithBytes:(long)loadBytes;

/*
 * 出错的时候上报
 */
-(void)requestEndWithError:(ALBBMANNetworkError*)error;

/*
 * 构造需要发送的
 */
-(NSDictionary*)build;
@end
