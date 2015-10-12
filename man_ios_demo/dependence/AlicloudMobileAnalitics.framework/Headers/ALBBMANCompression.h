//
//  ALBBMANCompression.h
//  AlicloudMobileAnalitics
//
//  Created by nanpo.yhl on 15/10/9.
//  Copyright (c) 2015年 com.aliyun.tds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBBMANCompression : NSObject

+(void)disableCompression;

+(BOOL)compressStatus;

/*
 * 压缩完以后，如果有数据需要send，那么返回需要传递的dic
 * 否则返回Nil
 */
+(void)CompressionNetworkEventWithProperties:(NSMutableDictionary*)properties;

+(void)CompressionCustomPerformanceEventProperties:(NSMutableDictionary*)properties;

@end
