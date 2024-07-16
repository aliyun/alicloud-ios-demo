//
//  HTTPDNSDemoUtils.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTTPDNSDemoUtils : NSObject

+ (NSArray *)domains;

+ (NSArray *)inputDomainsHistory;

+ (void)inputCacheAdd:(NSString *)domain;

+ (void)inputCacheRemove:(NSString *)domain;

+ (void)inputCacheRemoveAll;

@end

NS_ASSUME_NONNULL_END
