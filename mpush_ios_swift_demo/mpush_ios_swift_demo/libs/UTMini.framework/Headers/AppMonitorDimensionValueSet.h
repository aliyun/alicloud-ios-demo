//
//  AppMonitorDimensionValueSet.h
//  AppMonitor
//
//  Created by christ.yuj on 15/2/15.
//  Copyright (c) 2015年 君展. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
  其实就是个字典
 */
@interface AppMonitorDimensionValueSet : NSObject<NSCopying>

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 * 存储维度值
 */
@property (nonatomic, strong) NSMutableDictionary *dict;

- (void)setValue:(NSString *)value forName:(NSString *)name;
- (BOOL)containValueForName:(NSString *)name;
- (NSString *)valueForName:(NSString *)name;

@end
