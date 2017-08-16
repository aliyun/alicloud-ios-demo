//
//  TBCrashReporterGetData.h
//  TBCrashReporter
//
//  Created by qlb on 15/8/6.
//  Copyright (c) 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBCrashReporterGetData : NSObject

+ (instancetype)shareInstance;

- (NSString*)getWVURLData;

- (void)getMetaData:(NSMutableDictionary*) meta;

@end
