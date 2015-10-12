//
//  TDSTool.h
//  TestTDSQA
//
//  Created by 郭天 on 15/5/18.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDSArgs.h"

@interface TDSTool : NSObject

+ (long long)currentTimeInSec;

+ (NSString *)toStringWithServiceType:(TDSServiceType)serviceType;

@end
