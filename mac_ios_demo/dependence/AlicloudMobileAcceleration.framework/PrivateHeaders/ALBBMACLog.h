//
//  ALBBMACLog.h
//  ALBBMACSDK
//
//  Created by nanpo.yhl on 15/8/12.
//  Copyright (c) 2015年 com.taobao.com.cas. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALBBMAC_DEBUG(message, ...) [ALBBMACLog log:message, ##__VA_ARGS__]

@interface ALBBMACLog : NSObject
+ (void)log:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (void)turnOnDebug;
@end
