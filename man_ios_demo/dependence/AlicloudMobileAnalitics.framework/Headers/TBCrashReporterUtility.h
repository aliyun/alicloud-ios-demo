//
//  TBCrashReporterUtility.h
//  CrashReporterDemo
//
//  Created by 贾复 on 15/3/16.
//  Copyright (c) 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <mach/mach.h>

/**
 *  Crash 信息处理辅助
 */
@interface TBCrashReporterUtility : NSObject

/**
 *  Gzip压缩
 *
 *  @param theData 未压缩数据
 *
 *  @return 已压缩数据
 */
+ (NSData *)gzipData:(NSData *)theData;

/**
 *  Base64编码化
 *
 *  @param theData 未编码数据
 *
 *  @return 已编码字符串
 */
+ (NSString *)base64forData:(NSData *)theData;

/**
 *  用户操作路径，需要有依赖UT
 *
 *  @return 用户操作路径
 */
+ (NSString *)getUserPage;

/**
 *  Crash堆栈
 *
 *  @return Crash堆栈
 */
+ (NSString *)getBackTrace;

/**
 *  NSData 转 NSDictionary
 *
 *  @return 转成的Dic
 */
+ (NSDictionary *)dataToDic:(NSData*)data forkey:(NSString*)key;

/**
 *  合并Dictionary
 *
 *  @return 合并后的Dic
 */
+ (NSDictionary *)mergeDictionary:(NSDictionary *)dictLeft dictRight:(NSDictionary *)dictRight;



@end
