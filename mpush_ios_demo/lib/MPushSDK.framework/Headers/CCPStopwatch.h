//
//  CCPStopwatch.h
//  CloudPushSDK
//
//  Created by wuxiang on 14/11/1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

    // 用来记录 rpc 的耗时调用
@interface CCPStopwatch : NSObject

@property(readonly) double runtime;

-(void) start;

-(void) stop;

-(void) reset;

+ (instancetype)startNew ;

@end
