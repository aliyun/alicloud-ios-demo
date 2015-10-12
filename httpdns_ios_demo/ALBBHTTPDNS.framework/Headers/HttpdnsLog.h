//
//  HttpdnsLog.h
//  Dpa-Httpdns-iOS
//
//  Created by zhouzhuo on 5/2/15.
//  Copyright (c) 2015 zhouzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#define HttpdnsLogVerbose(frmt, ...)\
if ([HttpdnsLog isEnable]) {\
    NSLog((XCODE_COLORS_ESCAPE @"fg0,255,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__);\
}

#define HttpdnsLogDebug(frmt, ...)\
if ([HttpdnsLog isEnable]) {\
    NSLog((XCODE_COLORS_ESCAPE @"fg0,0,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__);\
}

#define HttpdnsLogError(frmt, ...)\
if ([HttpdnsLog isEnable]) {\
    NSLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__);\
}

extern BOOL HttpdnsLogIsEnable;

@interface HttpdnsLog : NSObject

+ (void)enbaleLog;

+ (void)disableLog;

+ (BOOL)isEnable;

@end
