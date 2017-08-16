//
//  AppMonitorMeasure.h
//  AppMonitor
//
//  Created by christ.yuj on 15/2/15.
//  Copyright (c) 2015年 君展. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppMonitorMeasureValue.h"
/**
 * 监控指标项
 *
 */

@interface AppMonitorMeasure : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *constantValue;
@property (nonatomic, strong) NSNumber *min;
@property (nonatomic, strong) NSNumber *max;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name constantValue:(NSNumber *)constantValue;
- (instancetype)initWithName:(NSString *)name constantValue:(NSNumber *)constantValue min:(NSNumber *)min max:(NSNumber *)max;
- (void)setRangeWithMin:(NSNumber *)min max:(NSNumber *)max;
- (BOOL)valid:(AppMonitorMeasureValue *)measureValue;
@end
