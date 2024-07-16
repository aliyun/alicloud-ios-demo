//
//  HTTPDNSDemoUtils.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/5.
//

#import "HTTPDNSDemoUtils.h"

static NSString *const configInfoFileName = @"httpdns-domains";
static NSString *const configInfoFileType = @"plist";
static NSString *const inputHistoryKey = @"httpdns-inputHistory";

@implementation HTTPDNSDemoUtils

+ (NSArray *)domains {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:configInfoFileName ofType:configInfoFileType];
    if (![HTTPDNSDemoTools isValidString:filePath]) {
        NSLog(@"Get domains is faild.");
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

@end
