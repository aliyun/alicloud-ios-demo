//
//  AppMonitorMeasureSet.h
//  AppMonitor
//
//  Created by christ.yuj on 15/2/15.
//  Copyright (c) 2015年 君展. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppMonitorMeasure.h"
#import "AppMonitorMeasureValueSet.h"
@interface AppMonitorMeasureSet : NSObject

/**
 * 根据列表初始化指标集合对象
 *
 * @param array NSString类型的数组 string为Name;
 * @return
 */

+ (instancetype)setWithArray:(NSArray *)array;

- (BOOL)valid:(NSString*)module MonitorPoint:(NSString*)monitorpoint measureValues:(AppMonitorMeasureValueSet *)measureValues;
/**
 * 增加指标
 *
 * @param measure 指标对象
 * @return
 */
- (void)addMeasure:(AppMonitorMeasure *)measure;

/**
 * 增加指标对象
 *
 * @param name 指标名称
 * @return
 */
- (void)addMeasureWithName:(NSString *)name;
/**
 * 获取指标对象
 *
 * @param name 指标名称
 * @return
 */
- (AppMonitorMeasure *)measureForName:(NSString *)name;

/**
 * 获取指标对象的列表
 *
 * @return
 */
- (NSMutableOrderedSet *)measures;

/**
 * 设置定值维度
 *
 * @param measureValues key为指标名称，value为内容
 */
- (void)setConstantValue:(AppMonitorMeasureValueSet *)measureValues;

@end
