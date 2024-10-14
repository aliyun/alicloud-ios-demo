//
//  MessageViewController.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/11.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageSingleTableViewCell.h"

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
}

#pragma mark - tableView delegate&dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // return self.pushMessage.count;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageSingleTableViewCell"];
    if (!cell) {
        cell = [[MessageSingleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageSingleTableViewCell"];
    }
    [cell setMessageTitle:@"我是预置推送消息"];
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

@end
