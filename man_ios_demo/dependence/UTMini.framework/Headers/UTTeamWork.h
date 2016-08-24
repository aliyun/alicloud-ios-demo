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

//该接口只针对于手淘,其他app请勿调用!!!!!
//ut初始化时写死手淘的一份配置到缓存中
+(void) loadConfsWhiteList;

//只有在白名单中的appkey才能使用该接口!!
+(void) forceUpload;

@end
