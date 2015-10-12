//
//  UTTeamWork.h
//  miniUTSDK
//
//  Created by 宋军 on 15/1/4.
//  Copyright (c) 2015年 ___SONGJUN___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTPlugin.h"
@interface UTTeamWork : NSObject

+(void) turnOnRealTimeDebug:(NSDictionary *) pDict;

+(void) trunOffRealTimeDebug;

+(void) registerPlugin:(NSObject<UTPlugin> *) pPlugin;

+(void) unregisterPlugin:(NSObject<UTPlugin> *) pPlugin;


@end
