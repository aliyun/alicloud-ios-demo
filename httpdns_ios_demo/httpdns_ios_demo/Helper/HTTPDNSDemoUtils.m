//
//  HTTPDNSDemoUtils.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/5.
//

#import "HTTPDNSDemoUtils.h"

static NSString *const kEmasInfoFileName = @"AliyunEmasServices-Info";
static NSString *const kEmasInfoFileType = @"plist";

static NSString *const configInfoFileName = @"httpdns-domains";
static NSString *const configInfoFileType = @"plist";
static NSString *const inputHistoryKey = @"httpdns-inputHistory";

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

@end
