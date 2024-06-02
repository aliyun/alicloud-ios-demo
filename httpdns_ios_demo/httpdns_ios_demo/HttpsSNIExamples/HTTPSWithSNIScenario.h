//
//  HTTPSWithSNIScene.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/5/24.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTTPSWithSNIScenario : NSObject

+ (void)httpDnsQueryWithURL:(NSString *)originalUrl completionHandler:(void(^)(NSString * message))completionHandler;

@end

NS_ASSUME_NONNULL_END
