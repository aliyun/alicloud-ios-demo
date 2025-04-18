//
//  CommonTools.h
//  apm_ios_demo
//
//  Created by Miracle on 2025/4/16.
//  Copyright © 2025 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonTools : NSObject

+ (void)userDefaultSetObject:(id)value forKey:(NSString *)key;

+ (id)userDefaultGet:(NSString *)key;

+ (void)setUpConfigWithAppKey:(NSString **)appKey appSecret:(NSString **)appSecret appRsaSecret:(NSString **)appRsaSecret functions:(NSArray **)functions;

@end

NS_ASSUME_NONNULL_END
