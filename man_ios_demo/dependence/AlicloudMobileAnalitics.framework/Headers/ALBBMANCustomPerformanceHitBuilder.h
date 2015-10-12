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

- (void)setProperties:(NSMutableDictionary *)properties;

- (void)hitStart;

- (void)hitEnd;

- (void)setDurationIntervalInMillis:(long long)intervalInMillis;

- (void)send;
@end
