//
//  AppMonitorMeasureValue.h
//  AppMonitor
//
//  Created by christ.yuj on 15/2/15.
//  Copyright (c) 2015年 君展. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 监控指标值
 *
 */

@interface AppMonitorMeasureValue : NSObject

/**
 * 耗时操作是否已经完成
 */
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, strong) NSNumber * offset;
@property (nonatomic, strong) NSNumber * value;

- (instancetype)initWithValue:(NSNumber *)value;
- (instancetype)initWithValue:(NSNumber *)value offset:(NSNumber *)offset;
- (void)merge:(AppMonitorMeasureValue *)measureValue;
//为了json序列化
- (NSDictionary *)jsonDict;
//json反序列化
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
