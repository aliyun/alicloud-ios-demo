//
//  HTTPDNSDemoUtils.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/5.
//

#import "HTTPDNSDemoUtils.h"

#pragma mark - file

static NSString *const kEmasInfoFileName = @"AliyunEmasServices-Info";
static NSString *const kEmasInfoFileType = @"plist";

static NSString *const configInfoFileName = @"httpdns-domains";
static NSString *const configInfoFileType = @"plist";

#pragma mark - cacheKey

static NSString *const inputHistoryKey = @"httpdns-inputHistory";

static NSString *const settingReuseExpiredIPKey = @"settingReuseExpiredIP";
static NSString *const settingPersistentCacheKey = @"settingPersistentCache";
static NSString *const settingHTTPSRequestKey = @"settingHTTPSRequest";
static NSString *const settingPreResolveAfterNetworkChangedKey = @"settingPreResolveAfterNetworkChanged";
static NSString *const settingLogEnabledKey = @"settingLogEnabled";
NSString *const settingRegionKey = @"settingRegion";
NSString *const settingTimeoutKey = @"settingTimeoutKey";

NSString *const settingPreResolveListKey = @"settingPreResolveListKey";
NSString *const settingCleanHostDomainKey = @"settingCleanHostDomainKey";


#pragma mark - URL

static NSString *const textUrlString = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt";
static NSString *const videoUrlString = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/file_example_MP4_640_3MG.mp4";

@implementation HTTPDNSDemoUtils

+ (int)accountId {
    NSDictionary *emasInfo = [self emasInfo];
    if (emasInfo == nil) {
        return 0;
    }
    int accountId = [emasInfo[@"config"][@"httpdns.accountId"] intValue];
    return accountId;
}

+ (NSString *)secretKey {
    NSDictionary *emasInfo = [self emasInfo];
    if (emasInfo == nil) {
        return nil;
    }
    NSString *secretKey = emasInfo[@"config"][@"httpdns.secretKey"];
    return secretKey;
}

+ (NSDictionary *)emasInfo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:kEmasInfoFileName ofType:kEmasInfoFileType];
    if (![HTTPDNSDemoTools isValidString:filePath]) {
        NSLog(@"Get plistFilePath fail.");
        return nil;
    }
    NSDictionary *emasInfo = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return emasInfo;
}

+ (NSArray *)domains {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:configInfoFileName ofType:configInfoFileType];
    if (![HTTPDNSDemoTools isValidString:filePath]) {
        NSLog(@"Get domains is faild.");//Get plistFilePath fail
        return nil;
    }

    NSArray *domains = [NSDictionary dictionaryWithContentsOfFile:filePath][@"domains"];
    return domains;
}

+ (NSArray *)inputDomainsHistory {
    NSArray *domainList = [HTTPDNSDemoTools userDefaultGet:inputHistoryKey];
    return domainList;
}

+ (void)inputCacheAdd:(NSString *)domain {
    NSMutableArray *domainList = [[HTTPDNSDemoTools userDefaultGet:inputHistoryKey] mutableCopy];
    if (domainList == nil) {
        domainList = [NSMutableArray arrayWithCapacity:1];
    }
    [domainList addObject:domain];
    [HTTPDNSDemoTools userDefaultSetObject:domainList forKey:inputHistoryKey];
}

+ (void)inputCacheRemove:(NSString *)domain {
    NSMutableArray *domainList = [[HTTPDNSDemoTools userDefaultGet:inputHistoryKey] mutableCopy];
    if ([domainList containsObject:domain]) {
        [domainList removeObject:domain];
    }
    [HTTPDNSDemoTools userDefaultSetObject:domainList forKey:inputHistoryKey];
}

+ (void)inputCacheRemoveAll {
    [HTTPDNSDemoTools userDefaultRemove:inputHistoryKey];
}

+ (NSString *)exampleTextUrlString {
    return textUrlString;
}

+ (NSString *)exampleVideoUrlString {
    return videoUrlString;
}

+ (NSArray<SettingInfoModel *> *)settingInfo {
    NSArray *infoArray = @[
        [[SettingInfoModel alloc]initWithTitle:@"允许过期IP" descripte:@"允许使用过期IP" switchIsOn:[HTTPDNSDemoTools userDefaultBool:settingReuseExpiredIPKey] cacheKey:settingReuseExpiredIPKey],
        [[SettingInfoModel alloc]initWithTitle:@"开启持久化缓存IP" descripte:@"域名解析结果，存储到本地数据库" switchIsOn:[HTTPDNSDemoTools userDefaultBool:settingPersistentCacheKey] cacheKey:settingPersistentCacheKey],
        [[SettingInfoModel alloc]initWithTitle:@"允许HTTPS" descripte:@"使用HTTPS协议解析" switchIsOn:[HTTPDNSDemoTools userDefaultBool:settingHTTPSRequestKey] cacheKey:settingHTTPSRequestKey],
        [[SettingInfoModel alloc]initWithTitle:@"网络切换自动刷新" descripte:@"网络切换后自动刷新解析结果缓存" switchIsOn:[HTTPDNSDemoTools userDefaultBool:settingPreResolveAfterNetworkChangedKey] cacheKey:settingPreResolveAfterNetworkChangedKey],
        [[SettingInfoModel alloc]initWithTitle:@"允许SDK打印日志" descripte:@"开启SDK打印日志" switchIsOn:[HTTPDNSDemoTools userDefaultBool:settingLogEnabledKey] cacheKey:settingLogEnabledKey],
    ];
    return infoArray;
}

+ (void)settingInfoChanged:(NSString *)cacheKey value:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        [HTTPDNSDemoTools userDefaultSetObject:value forKey:cacheKey];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *numberValue = (NSNumber *)value;
        if ([numberValue boolValue] == YES || [numberValue boolValue] == NO) {
            BOOL boolValue = [numberValue boolValue];
            [HTTPDNSDemoTools userDefaultSetBool:boolValue forKey:cacheKey];
        }
    } else {
        NSLog(@"Unsupported type");
    }
}

+ (BOOL)settingInfoBool:(settingInfoKey)cacheKey {
    BOOL isEnable = NO;
    switch (cacheKey) {
        case settingInfoReuseExpiredIPKey:
            isEnable = [HTTPDNSDemoTools userDefaultBool:settingReuseExpiredIPKey];
            break;
        case settingInfoPersistentCacheKey:
            isEnable = [HTTPDNSDemoTools userDefaultBool:settingPersistentCacheKey];
            break;
        case settingInfoHTTPSRequestKey:
            isEnable = [HTTPDNSDemoTools userDefaultBool:settingHTTPSRequestKey];
            break;
        case settingInfoPreResolveAfterNetworkChangedKey:
            isEnable = [HTTPDNSDemoTools userDefaultBool:settingPreResolveAfterNetworkChangedKey];
            break;
        case settingInfoLogEnabledKey:
            isEnable = [HTTPDNSDemoTools userDefaultBool:settingLogEnabledKey];
            break;

        default:
            break;
    }
    return isEnable;
}

+ (NSString *)settingInfo:(settingInfoKey)cacheKey {
    NSString *value;
    switch (cacheKey) {
        case settingInfoRegionKey:
            value = [HTTPDNSDemoTools userDefaultGet:settingRegionKey];
            break;
        case settingInfoTimeoutKey:
            value = [HTTPDNSDemoTools userDefaultGet:settingTimeoutKey];
            break;

        default:
            break;
    }
    return value;
}

+ (NSArray *)settingDomainListFor:(NSString *)cacheKey {
    NSArray *domains = [HTTPDNSDemoTools userDefaultGet:cacheKey];
    return domains;
}

+ (void)settingDomainListAdd:(NSString *)domain forKey:(NSString *)cacheKey {
    NSMutableArray *domainsArray = [(NSArray *)[HTTPDNSDemoTools userDefaultGet:cacheKey] mutableCopy];
    if (domainsArray == nil) {
        domainsArray = [NSMutableArray arrayWithCapacity:1];
    }
    [domainsArray addObject:domain];
    [HTTPDNSDemoTools userDefaultSetObject:domainsArray.copy forKey:cacheKey];
}

@end
