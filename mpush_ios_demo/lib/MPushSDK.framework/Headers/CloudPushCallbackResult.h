//
//  CloudPushCallbackResult.h
//  CloudPushSDK
//
//  Created by lingkun on 16/6/16.
//  Copyright © 2016年 aliyun.mobileService. All rights reserved.
//

#ifndef CloudPushCallbackResult_h
#define CloudPushCallbackResult_h

@interface CloudPushCallbackResult : NSObject

@property(nonatomic, readonly) BOOL success;

@property(nonatomic, readonly, nullable) id data;

@property(nonatomic, readonly, nullable) NSError *error;

+ (nonnull instancetype)resultWithData:(nullable id)data;

+ (nonnull instancetype)resultWithError:(nullable NSError *)error;

@end

#endif /* CloudPushCallbackResult_h */
