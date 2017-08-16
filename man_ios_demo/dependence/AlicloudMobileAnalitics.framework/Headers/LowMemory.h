//
//  LowMemory.h
//  TBCrashReporter
//
//  Created by qlb on 15/9/24.
//  Copyright (c) 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LowMemory : NSObject

+ (instancetype)shareInstance;

- (void) registLowMemoryObservers;

@end
