//
//  AppMonitorDimension.h
//  AppMonitor
//
//  Created by christ.yuj on 15/2/15.
//  Copyright (c) 2015年 君展. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 监控维度
 *
 */

@interface AppMonitorDimension : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *constantValue;

- (instancetype)initWithName:(NSString *)name;

- (instancetype)initWithName:(NSString *)name constantValue:(NSString *)constantValue;

@end
