//
//  AppMonitorDimensionSet.h
//  AppMonitor
//
//  Created by christ.yuj on 15/2/15.
//  Copyright (c) 2015年 君展. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppMonitorDimensionValueSet.h"
#import "AppMonitorDimension.h"
@interface AppMonitorDimensionSet : NSObject

/**
 * 根据列表初始化指标集合对象
 *
 * @param array NSString类型的数组 string为Name;
 * @return
 */

+ (instancetype)setWithArray:(NSArray *)array;

- (BOOL)valid:(AppMonitorDimensionValueSet*)dimensionValues;
/**
 * 增加维度
 *
 * @param dimension 维度对象
 * @return
 */
- (void)addDimension:(AppMonitorDimension *)dimension;

/**
 * 增加维度对象
 *
 * @param name 维度名称
 * @return
 */
- (void)addDimensionWithName:(NSString *)name;
/**
 * 获取维度对象
 *
 * @param name 维度名称
 * @return
 */
- (AppMonitorDimension *)dimensionForName:(NSString *)name;

- (NSMutableOrderedSet *)dimensions;

/**
 * 设置定值维度
 *
 * @param dimensionValues key为维度名称，value为内容
 */
- (void)setConstantValue:(AppMonitorDimensionValueSet *)dimensionValues;

@end
