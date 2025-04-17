//
//  CommonTools.m
//  apm_ios_demo
//
//  Created by Miracle on 2025/4/16.
//  Copyright © 2025 aliyun. All rights reserved.
//

#import "CommonTools.h"

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

@end
