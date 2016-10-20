//
//  NotificationViewController.m
//  mpush_content_extension
//  iOS 10 Notification Content Extension，通知内容扩展示例
//  收到通知进行下拉 or 3D touch展开通知详情时，可展示此处设置的样式
//
//  Created by junmo on 16/10/18.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = notification.request.content.body;
}

@end
