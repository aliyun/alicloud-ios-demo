//
//  EMASRest.h
//  EMASRest
//
//  Created by sky on 2020/6/11.
//  Copyright © 2020 aliyun. All rights reserved.
//

#import "EMASRestCacheConfig.h"

@interface EMASRestManager : NSObject


+ (void)turnOnDebug;

// 添加rest配置
+ (void)addRestCacheConfigs:(EMASRestCacheConfig *)config;

/**
 * 异步接口，注意数据大小不能超过30K
 */
+ (void)sendLogAsyncWithConfiguration:(EMASRestCacheConfig *)config aPageName:(NSObject *)aPageName eventId:(int) aEventId arg1:(NSString*) aArg1 arg2:(NSString*) aArg2 arg3:(NSString*) aArg3 args:(NSDictionary *) aArgs;

@end
