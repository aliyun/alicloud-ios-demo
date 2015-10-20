//
//  ALBBMASAggregation.h
//  TestMAS
//
//  Created by 郭天 on 15/3/17.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBBMASAggregation : NSObject

+ (void)putEvent:(NSString *)eventID property:(NSMutableDictionary *)requestInfo;

+ (void)enableAggregation:(BOOL)isEnable;

+ (void)putPageload:(NSString *)eventID property:(NSMutableDictionary *)requestInfo;

+ (void)putCustomPerformance:(NSString *)eventID property:(NSMutableDictionary *)requestInfo;

@end
