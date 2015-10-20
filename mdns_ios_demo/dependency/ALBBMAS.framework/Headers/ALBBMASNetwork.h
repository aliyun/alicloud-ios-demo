//
//  ALBBMASNetwork.h
//  TestMAS
//
//  Created by 郭天 on 15/2/10.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBBMASNetworkErrorInfo.h"

@interface ALBBMASNetwork : NSObject

+ (ALBBMASNetwork *)getInstance;

- (void)pageLoadStart;

- (void)pageLoadEnd:(long long)loadBytes and:(BOOL)isError;

#pragma mark- 同步埋点使用的接口

- (void)requestStart;

- (void)requestStartWithProperty:(NSMutableDictionary *)requestInfo;

- (void)requestFinishConnect;

- (void)requestReceiveFirstByte;

- (void)requestEndWithBytes:(long long)loadBytes;

- (void)reportRequestErrorWithErrorInfo:(ALBBMASNetworkErrorInfo *)errorInfo;

#pragma mark- 异步埋点使用的接口

- (void)requestStartWithContext:(NSString *)eventContext;

- (void)requestStartWithContext:(NSString *)eventContext property:(NSMutableDictionary *)requestInfo;

- (void)requestFinishConnectWithContext:(NSString *)eventContext;

- (void)requestReceiveFirstByteWithContext:(NSString *)eventContext;

- (void)requestEndWithContext:(NSString *)eventContext bytes:(long long)loadBytes;

- (void)reportRequestErrorWithContext:(NSString *)eventContext errorInfo:(ALBBMASNetworkErrorInfo *)errorInfo;

@end
