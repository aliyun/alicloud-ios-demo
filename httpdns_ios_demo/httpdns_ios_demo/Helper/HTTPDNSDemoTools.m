//
//  HTTPDNSDemoTools.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/5.
//

#import "HTTPDNSDemoTools.h"

@implementation HTTPDNSDemoTools

+ (BOOL)isValidString:(id)obj {
    if ((obj != nil) && ([obj isKindOfClass:[NSString class]])) {
        NSString *str = obj;
        return (str.length > 0);
    }
    return NO;
}

+ (id)storyBoardInstantiateViewController:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

+ (void)userDefaultSetObject:(id)value forKey:(NSString *)key {
    if (key) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)userDefaultSetBool:(BOOL)value forKey:(NSString *)key {
    if (key) {
        [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (id)userDefaultGet:(NSString *)key {
    if (key) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return nil;
}

+ (BOOL)userDefaultBool:(NSString *)key {
    if (key) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:key];
    }
    return NO;
}

+ (void)userDefaultRemove:(NSString *)key {
    if (key) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
