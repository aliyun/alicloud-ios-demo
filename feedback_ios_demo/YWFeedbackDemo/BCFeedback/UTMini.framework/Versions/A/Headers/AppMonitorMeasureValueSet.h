//
//  AppMonitorMeasureValueSet.h
//  AppMonitor
//
//  Created by christ.yuj on 15/2/15.
//  Copyright (c) 2015年 君展. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppMonitorMeasureValue.h"
@interface AppMonitorMeasureValueSet : NSObject<NSCopying>


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


/**
 * 设置指标值
 *
 * @param name
 * @param value
 * @return
 */
- (void)setDoubleValue:(double)value forName:(NSString *)name;
- (void)setValue:(AppMonitorMeasureValue *)value forName:(NSString *)name;
- (BOOL)containValueForName:(NSString *)name;
- (AppMonitorMeasureValue *)valueForName:(NSString *)name;
/**
 *  合并指标
 *
 *  @param measureValueSet 目标指标集合
 *  发现相同的name就对MeasureValue做加操作
 */
- (void)merge:(AppMonitorMeasureValueSet*)measureValueSet;

- (NSDictionary *)jsonDict;

@end
