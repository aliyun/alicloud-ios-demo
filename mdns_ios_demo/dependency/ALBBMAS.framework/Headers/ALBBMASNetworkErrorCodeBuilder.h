//
//  ALBBMASNetworkErrorCodeBuilder.h
//  ALBB_MAS_IOS_SDK
//
//  Created by 郭天 on 15/5/27.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBBMASNetworkErrorInfo.h"

@interface ALBBMASNetworkErrorCodeBuilder : NSObject

+ (ALBBMASNetworkErrorInfo *)buildHttpCodeClientError4XX;
+ (ALBBMASNetworkErrorInfo *)buildHttpCodeServerError5XX;
+ (ALBBMASNetworkErrorInfo *)buildMalformedURLException;
+ (ALBBMASNetworkErrorInfo *)buildInterruptedIOException;
+ (ALBBMASNetworkErrorInfo *)buildSocketTimeoutException;
+ (ALBBMASNetworkErrorInfo *)buildIOException;
+ (ALBBMASNetworkErrorInfo *)buildCustomErrorCode:(NSString *)code;
+ (ALBBMASNetworkErrorInfo *)buildErrorCode:(NSString *)code;

@end
