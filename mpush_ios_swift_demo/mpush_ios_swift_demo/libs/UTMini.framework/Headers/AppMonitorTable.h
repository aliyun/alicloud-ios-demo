//
//  AppMonitorStat2.h
//  AppMonitor
//
//  Created by sugar on 7/8/15.
//  Copyright (c) 2015 君展. All rights reserved.
//

#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////
//  数据格式以下图为例：
//  启动性能 - 启动时间监控
//  启动方式  | cpu | 机型 | 网络类型| 总计
//  ----------------------------------
//  冷启动耗时 |arm7 | 4s  | 2G    |  5s （约束2-10）
//  热启动耗时 |arm7s| 5s  | 4G    |  3s （约束1-3）

//  step 1: 创建一个模块空间；monitorForScheme
//  step 2: 在空间下面创建表
//  step 3: 添加对应的值的约束，不在约束范围内的点将一噪点方式上报
//  step 4: 更新表数据
//

/////////////////////////////////////////////////////////


@interface AppMonitorTable : NSObject

// BEGIN Add by 玄叶
+ (void)registerWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint columns:(NSArray *)cols rows:(NSArray * )rows aggregate:(BOOL)aggregate;

+ (void)addConstraintWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint name:(NSString *)name min:(double)min max:(double)max defaultValue:(double)value;

+ (BOOL)commitWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint columns:(NSDictionary *)cols rows:(NSDictionary *)rows;
// END

// 创建一个表的模块空间
+ (instancetype)monitorForScheme:(NSString *)scheme tableName:(NSString *)tableName;

// 新建一张表, 行，列，数据是否聚合
- (void)registerTableWithRows:(NSArray * )rows columns:(NSArray *)cols aggregate:(BOOL)yn;

// 添加约束
- (void)addConstraintWithName:(NSString *)name range:(NSRange)range defaultValue:(NSNumber *)number;

// 添加约束
- (void)addConstraintWithName:(NSString *)name min:(double)min max:(double)max defaultValue:(double)value;

// 更新表 行的名字，列的名字，行的数据，列的数据
- (BOOL)updateTableForColumns:(NSDictionary *)cols rows:(NSDictionary *)rows;

// 更新表，不区分行列名字。此接口不允许行列同名，性能偏低，慎用！
- (BOOL)updateTableWithDictionary:(NSDictionary *)dict;

@end