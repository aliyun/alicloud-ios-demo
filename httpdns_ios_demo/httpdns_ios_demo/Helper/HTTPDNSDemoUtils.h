//
//  HTTPDNSDemoUtils.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/5.
//

#import <Foundation/Foundation.h>
#import "SettingInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    settingInfoReuseExpiredIPKey,
    settingInfoPersistentCacheKey,
    settingInfoHTTPSRequestKey,
    settingInfoPreResolveAfterNetworkChangedKey,
    settingInfoLogEnabledKey,
    settingInfoRegionKey,
    settingInfoTimeoutKey
} settingInfoKey;

extern NSString *const settingRegionKey;
extern NSString *const settingTimeoutKey;

@interface HTTPDNSDemoUtils : NSObject

+ (int)accountId;

+ (NSString *)secretKey;

+ (NSArray *)domains;

+ (NSArray *)inputDomainsHistory;

+ (void)inputCacheAdd:(NSString *)domain;

+ (void)inputCacheRemove:(NSString *)domain;

+ (void)inputCacheRemoveAll;

+ (NSString *)exampleTextUrlString;

+ (NSString *)exampleVideoUrlString;

+ (NSArray<SettingInfoModel *> *)settingInfo;

+ (void)settingInfoChanged:(NSString *)cacheKey value:(id)value;

+ (NSString *)settingInfo:(settingInfoKey)cacheKey;

+ (BOOL)settingInfoBool:(settingInfoKey)cacheKey;

@end

NS_ASSUME_NONNULL_END
