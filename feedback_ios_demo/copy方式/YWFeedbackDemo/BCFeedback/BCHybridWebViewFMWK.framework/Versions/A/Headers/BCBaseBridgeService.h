//
//  YWBaseBridgeService.h
//  xBlink
//
//  Created by admin on 14-11-11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCHybridEngine.h"
//#import "IXBHybridAppConfig.h"

@protocol YWBaseBridgeService <NSObject>
+ (void)registerWQService:(YWHybridEngine *)engine;
@end
