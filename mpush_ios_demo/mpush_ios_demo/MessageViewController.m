//
//  MessageViewController.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/11.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "PushMessageDAO.h"
#import "MsgToolBox.h"

@interface MessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@property NSMutableArray *pushMessage;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;

    self.pushMessage = [NSMutableArray arrayWithCapacity:1];

    [self refreshMessageList];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageList) name:@"PUSHMESSAGE_INSERT" object:nil];
}

- (void)refreshMessageList {
    PushMessageDAO *messageDAO = [[PushMessageDAO alloc] init];
    self.pushMessage = messageDAO.selectAll;

    [self.messageTableView reloadData];
}

#pragma mark - tableView delegate&dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.pushMessage.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageTableViewCell"];
    }
    LZLPushMessage *message = self.pushMessage[indexPath.section];
    [cell setMessageTitle:message.messageTitle];
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
    LZLPushMessage *message = self.pushMessage[indexPath.section];
    [MsgToolBox showAlert:message.messageTitle content:message.messageContent];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除cell
    if (editingStyle == UITableViewCellEditingStyleDelete){
        // 数据库中删除该条记录
        PushMessageDAO *dao = [[PushMessageDAO alloc] init];
        [dao remove:[self.pushMessage objectAtIndex:indexPath.section]];
        // 数据源中剔除记录
        [self.pushMessage removeObjectAtIndex:indexPath.section];

        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
