#import "EAPMDemoConfigStore.h"

#import "EAPMDemoConstants.h"

@implementation EAPMDemoConfigStore

+ (void)userDefaultSetObject:(id)value forKey:(NSString *)key {
    if (key) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (value) {
            [defaults setObject:value forKey:key];
        } else {
            [defaults removeObjectForKey:key];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (id)userDefaultGet:(NSString *)key {
    if (key) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return nil;
}

+ (nullable NSString *)normalizedValue:(nullable NSString *)value {
    NSString *trimmedValue = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedValue.length > 0 ? trimmedValue : nil;
}

+ (nullable NSString *)storedUserId {
    NSString *userId = (NSString *)[self userDefaultGet:kDemoUserId];
    return [self normalizedValue:userId];
}

+ (nullable NSString *)storedUserNick {
    NSString *userNick = (NSString *)[self userDefaultGet:kDemoUserNick];
    return [self normalizedValue:userNick];
}

+ (void)saveUserId:(nullable NSString *)userId userNick:(nullable NSString *)userNick {
    [self userDefaultSetObject:[self normalizedValue:userId] forKey:kDemoUserId];
    [self userDefaultSetObject:[self normalizedValue:userNick] forKey:kDemoUserNick];
}

@end
