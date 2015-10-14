//
//  ALBBMANCustomPerformance.h
//   
//
//  Created by 郭天 on 15/5/28.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBBMANCustomPerformanceHitBuilder : NSObject

- (instancetype)init:(NSString *)eventName;

/*
 * 用户可以自行设置属性，但是不要包含“/Host/Method/EVENTID/PAGE/ARG1/ARG2/ARG3/ARGS/COMPRESS”
 */
- (void)setProperty:(NSString *) pKey value:(NSString *) pValue;

- (void)setProperties:(NSMutableDictionary *)properties;

- (void)hitStart;

- (void)hitEnd;

- (void)setDurationIntervalInMillis:(long long)intervalInMillis;

/*
 * 构造需要发送的
 */
-(NSDictionary*)build;
@end
