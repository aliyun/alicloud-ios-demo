//
//  ALBBMASCustomPerformance.h
//  ALBB_MAS_IOS_SDK
//
//  Created by 郭天 on 15/5/28.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBBMASCustomPerformanceHitBuilder : NSObject

- (instancetype)init:(NSString *)performanceName;
- (void)setProperties:(NSMutableDictionary *)properties;
- (void)hitStart;
- (void)hitEnd;
- (void)setDurationIntervalInMillis:(long long)intervalInMillis;
- (void)send;

@end
