//
//  BCUtil.h
//  WQConnector
//
//  Created by qinghua.liqh on 14-2-22.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCHandlerResult.h"
#define WQUtil BCUtil

@interface WQUtil : NSObject
#pragma mark - URL处理相关
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params needURLEncoding:(BOOL)needURLEncoding;
//将dict中的数据转换为字符串，可以选择是否需要urlencoding
+ (NSString *)stringFromDictionary:(NSDictionary *)dict needURLEncoding:(BOOL)needURLEncoding;
+ (NSString *)stringFromHandlerResult:(WQHandlerResult *)result needURLEncoding:(BOOL)needURLEncoding;
+ (NSDictionary *)parseParamsFromsString:(NSString *)strValue;
+ (NSString *)combineUriWithEvent:(NSString *)event path:(NSString *)path params:(NSDictionary *)params;
+ (NSString *)urlWithremoveParams:(NSString *)url;
+ (NSString *)addParamToUrl:(NSString *)url paramKey:(NSString *)paramKey paramValue:(NSString *)paramValue;
+ (BOOL) checkUrlHasParam:(NSString *)url withParamKey:(NSString *) paramKey;

#pragma mark - 文件路径处理相关
+ (void)createFolderIfNotExist:(NSString *)folderPath;

/// 检查url是否有scheme，如果没有默认添加http
+ (NSString *)checkUrlStringScheme:(NSString *)url;
+ (NSURL *)checkUrlScheme:(NSURL *)url;

@end
