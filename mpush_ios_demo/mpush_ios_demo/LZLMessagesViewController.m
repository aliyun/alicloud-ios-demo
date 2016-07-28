//
//  LZLMessagesViewController.m
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/4/1.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "LZLMessagesViewController.h"
#import "PushMessageDAO.h"
#import <QuartzCore/QuartzCore.h>
#import "KoaPullToRefresh.h"

@interface LZLMessagesViewController ()

@property NSMutableArray *pushMessage;

@end

@implementation LZLMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pushMessageTableView.delegate = self;
    self.pushMessageTableView.dataSource = self;
    
    self.pushMessage = [[NSMutableArray alloc] init];
    
    [self.pushMessageTableView addPullToRefreshWithActionHandler:^{
        [self refreshTable];
    } withBackgroundColor:[UIColor colorWithRed:0.251 green:0.663 blue:0.827 alpha:1] withPullToRefreshHeightShowed:1];
    
    // Customize pulltorefresh text colors
    [self.pushMessageTableView.pullToRefreshView setTextColor:[UIColor whiteColor]];
    [self.pushMessageTableView.pullToRefreshView setTextFont:[UIFont fontWithName:@"OpenSans-Semibold" size:16]];
    
    // Set fontawesome icon
    [self.pushMessageTableView.pullToRefreshView setFontAwesomeIcon:@"icon-refresh"];
    
    // Set titles
    [self.pushMessageTableView.pullToRefreshView setTitle:@"Pull" forState:KoaPullToRefreshStateStopped];
    [self.pushMessageTableView.pullToRefreshView setTitle:@"Release" forState:KoaPullToRefreshStateTriggered];
    [self.pushMessageTableView.pullToRefreshView setTitle:@"Loading" forState:KoaPullToRefreshStateLoading];
    
    // Hide scroll indicator
    [self.pushMessageTableView setShowsVerticalScrollIndicator:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.pushMessageTableView.pullToRefreshView startAnimating];
    [self.pushMessageTableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    [self refreshTable];
}

- (void)refreshTable {
    PushMessageDAO *dao = [[PushMessageDAO alloc] init];
    self.pushMessage = dao.selectAll;
    
    [self.pushMessageTableView reloadData];
    
    [self.pushMessageTableView performSelector:@selector(reloadData) withObject:nil afterDelay:1.5];
    [self.pushMessageTableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ===================================== Table View Method ====================================
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除cell
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // 数据库中删除该条记录
        PushMessageDAO *dao = [[PushMessageDAO alloc] init];
        [dao remove:[self.pushMessage objectAtIndex:indexPath.row]];
        
        [self.pushMessage removeObjectAtIndex:indexPath.row];  // 数据源中剔除记录
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pushMessage count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"pushMessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    LZLPushMessage *tablecell = [self.pushMessage objectAtIndex:indexPath.row];
    cell.textLabel.text = tablecell.messageContent;
    
    if (tablecell.isRead) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LZLPushMessage *tappedItem = [self.pushMessage objectAtIndex:indexPath.row];
    
    if (tappedItem.isRead) {
        
    } else {
        tappedItem.isRead = 1;
        PushMessageDAO *dao = [[PushMessageDAO alloc] init];
        [dao update:tappedItem];
        
        [self refreshTable];
    }
}

@end
