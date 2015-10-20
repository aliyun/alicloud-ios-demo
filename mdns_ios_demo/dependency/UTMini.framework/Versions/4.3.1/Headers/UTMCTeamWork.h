//
//  UTMCTeamWork.h
//  minimalUT4ios
//
//  Created by 宋军 on 15/1/4.
//  Copyright (c) 2015年 ___ALIBABA___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTPlugin.h"
@interface UTMCTeamWork : NSObject

+(void) turnOnRealTimeDebug:(NSDictionary *) pDict;

+(void) trunOffRealTimeDebug;

+(void) registerPlugin:(NSObject<UTPlugin> *) pPlugin;

+(void) unregisterPlugin:(NSObject<UTPlugin> *) pPlugin;


@end
