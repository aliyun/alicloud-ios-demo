//
//  ALBBMANTool.h
//   
//
//  Created by 郭天 on 15/2/10.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBBMANTool : NSObject

+ (long long)currentTimeInMillis;


+ (BOOL)isNotNilOrEmpty:(NSString *)str;


+ (BOOL)isLegalHost:(NSString *)host;


+ (BOOL)isLegalIP:(NSString *)ip;


+ (BOOL)isLegalPerformanceName:(NSString *)performanceName;


+ (void)commitEvent:(NSString *)eventId property:(NSMutableDictionary *)tempProperty;
@end
