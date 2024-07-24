//
//  HTTPDNSDemoUtils.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

@end

NS_ASSUME_NONNULL_END
