//
//  TBCrashMarker.h
//  TBCrashReporter
//
//  1) create mark in file once application launched
//  2) page path will be written once page changed
//  3) erase the mark once application exists normally or crash was caught
//  4) check and upload the mark(including the page path) once app was launched again
//  Created by hansong.lhs on 15/9/4.
//  Copyright (c) 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBCrashMarker : NSObject

+ (instancetype) instance;

#pragma register observer for app start and finish
- (void) registerLifeCycleObservers:(NSString*)appVersion;

#pragma create marker file on crash
- (void) createCrashMarker;

@end