//
//  ABSUtil.h
//  AntilockBrakeSystem
//
//  Created by 地风（ElonChan） on 16/5/16.
//  Copyright © 2016年 Ali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABSUtil : NSObject

// 设置日志逻辑
+ (void)setLogger:(void (^)(NSString *))logger;

+ (void)Logger:(NSString *)log;

+ (BOOL)isValidString:(id)notValidString;

+ (BOOL)isWhiteListClass:(Class)class;

+ (void)deleteCacheWithfilePathsToRemove:(NSArray *)filePathsToRemove;

@end
