//
//  SilentNotificationViewController.m
//  mpush_ios_demo
//
//  Created by Miracle on 2025/9/1.
//  Copyright © 2025 alibaba. All rights reserved.
//

#import "SilentNotificationViewController.h"
#import "NotificationDataManager.h"
#import "MessageTableViewCell.h"

@interface SilentNotificationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *notificationTableView;

@property (nonatomic, strong) NSMutableArray *pushNotifications;

@end

@implementation SilentNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.notificationTableView.delegate = self;
    self.notificationTableView.dataSource = self;
    self.notificationTableView.showsVerticalScrollIndicator = NO;

    [self refreshList];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"PUSHNOTIFICATION_INSERT" object:nil];
}

- (void)refreshList {
    self.pushNotifications = [[NotificationDataManager getCacheNotifications] mutableCopy];

    [self.notificationTableView reloadData];
}

#pragma mark - tableView delegate&dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.pushNotifications.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationTableViewCell"];
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotificationTableViewCell"];
    }

    NSDictionary *NotificationData = self.pushNotifications[indexPath.section];
    [cell setMessageTitle:[NotificationData valueForKey:@"notificationId"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *NotificationData = self.pushNotifications[indexPath.section];
    NSMutableString *dataString = [NSMutableString string];
    [dataString appendFormat:@"id:%@\n", [NotificationData valueForKey:@"notificationId"]];
    [dataString appendFormat:@"extParameters:%@", [NotificationData valueForKey:@"extParameters"]];
    [MsgToolBox showAlert:@"SilentNotification" content:dataString];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除cell
    if (editingStyle == UITableViewCellEditingStyleDelete){
        // 删除该条记录
        [NotificationDataManager removeNotification:[self.pushNotifications objectAtIndex:indexPath.section]];
        // 数据源中剔除记录
        [self.pushNotifications removeObjectAtIndex:indexPath.section];

        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark - lazy load

- (NSMutableArray *)pushNotifications {
    if (!_pushNotifications) {
        _pushNotifications = [NSMutableArray array];
    }
    return _pushNotifications;
}

@end
