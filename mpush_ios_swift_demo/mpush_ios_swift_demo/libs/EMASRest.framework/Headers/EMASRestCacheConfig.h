//
//  EMASRestCacheConfig.h
//  AlicloudCommonAnalytics
//
//  Created by sky on 2020/7/27.
//

#import <Foundation/Foundation.h>

#import "EMASRestConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMASRestCacheConfig : NSObject
@property (nonatomic, assign) int memoryCacheSizeLimit; // 内存size限制
@property (nonatomic, assign) int memoryCacheCountLimit; // 日志条数限制
@property (nonatomic, assign) BOOL memoryCacheSwitch; // 内存缓存开关
@property (nonatomic, assign) BOOL diskCacheSwitch; // 磁盘缓存开关

@property (nonatomic, strong) NSString *cacheName; // 缓存标识,默认为common

// 缓存标识，对应一个实例。
// dataUploadHost+appkey+cacheName共同确认一个实例
@property (nonatomic, strong) NSString *cacheKey;

@property (nonatomic, strong) EMASRestConfiguration *restConfig;

// 是否有效
- (BOOL)isValid;

@end

NS_ASSUME_NONNULL_END
