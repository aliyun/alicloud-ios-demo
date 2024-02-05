//
//  EMASTools.h
//  AlicloudUtils
//
//  Created by junmo on 2018/3/14.
//  Copyright © 2018年 Ali. All rights reserved.
//

#ifndef EMASTools_h
#define EMASTools_h

#define EMAS_SYNC_EXECUTE_BY_KEY(key, executor)\
[EMASTools syncExecuteBlockByKey:key block:executor];\

#define EMAS_SYNC_EXECUTE_BY_QUEUE(queue, executor)\
[EMASTools syncExecuteBlockByQueue:queue block:executor];\

@interface EMASTools : NSObject

+ (BOOL)isValidString:(id)obj;
+ (BOOL)isValidDictionary:(id)obj;
+ (BOOL)isValidArray:(id)obj;

+ (NSString *)md5:(NSString *)str;
+ (NSString *)sha1:(NSString *)str;
+ (NSString *)hmacSha1:(NSString *)str key:(NSString *)key;
+ (NSString *)base64EncodedWithString:(NSString *)str;
+ (NSString *)base64DecodedWithString:(NSString *)base64Str;
+ (NSData *)aes128CBCEncrypt:(NSData *)data key:(NSData *)key iv:(char *)iv;
+ (NSString *)URLEncodedString:(NSString *)str;

+ (NSString *)convertObjectToJsonString:(id)obj;
+ (id)convertJsonStringToObject:(NSString *)jsonStr;
+ (id)convertJsonDataToObject:(NSData *)jsonData;

+ (NSString *)convertDateToGMT0String:(NSDate *)date;
+ (NSString *)convertDateToGMT8String:(NSDate *)date;

+ (void)swizzleClassMethod:(Class)cls originSEL:(SEL)originSEL swizzleSEL:(SEL)swizzleSEL;
+ (void)swizzleInstanceMethod:(Class)cls originSEL:(SEL)originSEL swizzleSEL:(SEL)swizzleSEL;

+ (BOOL)isIPv4Address:(NSString *)addr;
+ (BOOL)isIPv6Address:(NSString *)addr;

+ (dispatch_queue_t)createQueueIfNotExists:(NSString *)key;
+ (void)syncExecuteBlockByKey:(NSString *)key block:(void(^)(void))block;
+ (void)syncExecuteBlockByQueue:(dispatch_queue_t)queue block:(void(^)(void))block;

+ (NSString *)bundleIdForApp;
+ (NSString *)deviceBrand;
+ (NSString *)deviceModel;

+ (void)threadWaitForSec:(double)sec;

@end

#endif /* EMASTools_h */
