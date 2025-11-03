//
//  EmasCurlScenario.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2025/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmasCurlScenario : NSObject

+ (void)httpDnsQueryWithURL:(NSString *)originalUrl completionHandler:(void(^)(NSString * message))completionHandler;

@end

NS_ASSUME_NONNULL_END
