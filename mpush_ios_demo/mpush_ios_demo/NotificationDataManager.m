//
//  NotificationDataManager.m
//  mpush_ios_demo
//
//  Created by Miracle on 2025/9/1.
//  Copyright © 2025 alibaba. All rights reserved.
//

#import "NotificationDataManager.h"

@implementation NotificationDataManager

+ (NSString *)notificationDataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject];
    return [documentsPath stringByAppendingPathComponent:@"notifications.json"];
}

+ (void)saveNotificationData:(NSDictionary *)userInfo {
    NSString *notificationId = [[userInfo valueForKey:@"i"] stringValue];

    NSMutableDictionary *extParameters = [NSMutableDictionary dictionary];
    for (NSString *key in userInfo.allKeys) {
        if (![key isEqualToString:@"m"] && ![key isEqualToString:@"exts"] && ![key isEqualToString:@"x"] && ![key isEqualToString:@"aps"] && ![key isEqualToString:@"i"]) {
            [extParameters setObject:[userInfo valueForKey:key] forKey:key];
        }
    }

    // 获取当前的缓存数据
    NSMutableArray *cachedNotifications = [NSMutableArray arrayWithArray:[self getCacheNotifications]];
    // 添加新的数据
    NSDictionary *newNotification = @{
        @"notificationId": notificationId ?: @"",
        @"extParameters": extParameters
    };
    [cachedNotifications addObject:newNotification];

    // 写回到文件
    NSString *filePath = [self notificationDataFilePath];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cachedNotifications options:NSJSONWritingPrettyPrinted error:nil];
    if ([jsonData writeToFile:filePath atomically:YES]) {
        NSLog(@"已写入到文件: %@", filePath);
    } else {
        NSLog(@"写入文件失败");
    }
}

+ (NSArray *)getCacheNotifications {
    // 获取当前的缓存数据
    NSMutableArray *cachedNotifications = [NSMutableArray array];
    NSString *filePath = [self notificationDataFilePath];
    NSData *existingData = [NSData dataWithContentsOfFile:filePath];
    if (existingData) {
        NSArray *existingArray = [NSJSONSerialization JSONObjectWithData:existingData options:0 error:nil];
        if (existingArray) {
            [cachedNotifications addObjectsFromArray:existingArray];
        }
    }
    return cachedNotifications.copy;
}

+ (void)removeNotification:(id)data {
    // 获取当前的缓存数据
    NSMutableArray *cachedNotifications = [NSMutableArray arrayWithArray:[self getCacheNotifications]];

    for (NSDictionary *notification in cachedNotifications) {
        if ([[notification valueForKey:@"notificationId"] isEqualToString:[data valueForKey:@"notificationId"]]) {
            [cachedNotifications removeObject:notification];
            // 写回到文件
            NSString *filePath = [self notificationDataFilePath];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cachedNotifications options:NSJSONWritingPrettyPrinted error:nil];
            if ([jsonData writeToFile:filePath atomically:YES]) {
                NSLog(@"已写入到文件: %@", filePath);
            } else {
                NSLog(@"写入文件失败");
            }
            return;
        }
    }
}

@end
