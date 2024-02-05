//
//  AlicloudSender.h
//  AlicloudSender
//
//  Created by sky on 2021/1/25.
//  Copyright © 2021 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALICLOUDRESTSEND_VERSION @"1.0.0.3"

//! Project version number for AlicloudSender.
FOUNDATION_EXPORT double AlicloudSenderVersionNumber;

//! Project version string for AlicloudSender.
FOUNDATION_EXPORT const unsigned char AlicloudSenderVersionString[];


NS_ASSUME_NONNULL_BEGIN

@interface AlicloudSender : NSObject

+ (instancetype)shareInstance;

- (void)sendEvent:(NSString *)event appKey:(NSString *)appkey sdkId:(NSString *)sdkId sdkVersion:(NSString *)sdkVersion extParams:(NSDictionary *)extParams;

@end

NS_ASSUME_NONNULL_END
