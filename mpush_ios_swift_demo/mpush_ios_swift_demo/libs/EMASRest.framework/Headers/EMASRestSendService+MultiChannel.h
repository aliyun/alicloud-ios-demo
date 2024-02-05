//
//  EMASRestSendService+MultiChannel.h
//  AlicloudCommonAnalytics
//
//  Created by sky on 2020/6/11.
//  Copyright © 2020 aliyun. All rights reserved.
//

#import "EMASRestSendService.h"
#import "EMASRestConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMASRestSendService (MultiChannel)
/**
 * 异步接口，注意数据大小不能超过30K
 */
+ (void)sendLogAsyncWithConfiguration:(EMASRestConfiguration*)configuration aPageName:(NSObject *)aPageName eventId:(int) aEventId arg1:(NSString*) aArg1 arg2:(NSString*) aArg2 arg3:(NSString*) aArg3 args:(NSDictionary *) aArgs;


/**
 * 同步接口，注意数据大小不能超过30K
 */
+ (BOOL)sendLogSyncWithConfiguration:(EMASRestConfiguration*)configuration aPageName:(NSObject *)aPageName eventId:(int) aEventId arg1:(NSString *) aArg1 arg2:(NSString *) aArg2 arg3:(NSString *) aArg3 args:(NSDictionary *) aArgs;


@end

NS_ASSUME_NONNULL_END
