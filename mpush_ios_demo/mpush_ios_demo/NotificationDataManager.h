//
//  NotificationDataManager.h
//  mpush_ios_demo
//
//  Created by Miracle on 2025/9/1.
//  Copyright © 2025 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationDataManager : NSObject

+ (void)saveNotificationData:(NSDictionary *)userInfo;

+ (NSArray *)getCacheNotifications;

+ (void)removeNotification:(id)data;

@end

NS_ASSUME_NONNULL_END
