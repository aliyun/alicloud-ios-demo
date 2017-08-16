//
//  CycleFileWriter.h
//  TBCrashReporter
//
//  writer with cycle, given fixed number of lines, and only keep last no. of lines
//  Created by hansong.lhs on 15/9/7.
//  Copyright (c) 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CycleFileWriter : NSObject

#pragma construct method with file dir and number of lines
- (instancetype) init:(NSString*)fileDir maxNumLines:(int)maxNumLines;

#pragma append new line
- (void) appendLine:(NSString*)newLine;

@end