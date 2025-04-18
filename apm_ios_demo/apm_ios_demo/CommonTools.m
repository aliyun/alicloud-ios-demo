//
//  CommonTools.m
//  apm_ios_demo
//
//  Created by Miracle on 2025/4/16.
//  Copyright © 2025 aliyun. All rights reserved.
//

#import "CommonTools.h"
#import "Macros.h"

@implementation CommonTools

+ (void)userDefaultSetObject:(id)value forKey:(NSString *)key {
    if (key) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (id)userDefaultGet:(NSString *)key {
    if (key) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return nil;
}

+ (void)setUpConfigWithAppKey:(NSString **)appKey appSecret:(NSString **)appSecret appRsaSecret:(NSString **)appRsaSecret functions:(NSArray **)functions {
    if ([*appKey isEqualToString:@"请替换您的appKey"]) {
        *appKey = (NSString *)[CommonTools userDefaultGet:kAppKey];
    }

    if ([*appSecret isEqualToString:@"请替换您的appSecret"]) {
        *appSecret = (NSString *)[CommonTools userDefaultGet:kAppSecret];
    }

    if ([*appRsaSecret isEqualToString:@"请替换您的appRsaSecret"]) {
        *appRsaSecret = (NSString *)[CommonTools userDefaultGet:kAppRsaSecret];
    }

    NSArray *localFunctions = (NSArray *)[CommonTools userDefaultGet:kFunctions];
    if (localFunctions && localFunctions.count >= 0) {
        NSMutableArray *functionsClass = [NSMutableArray array];
        for (NSString *function in localFunctions) {
            [functionsClass addObject:NSClassFromString(function)];
        }
        *functions = functionsClass;
    }
}

@end
