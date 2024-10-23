//
//  SettingViewController.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/16.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "SettingViewController.h"
#import "CustomAlertView.h"
#import "CustomToastUtil.h"
#import "SettingSingleTableViewCell.h"
#import "SettingAliasTableViewCell.h"
#import <CloudPushSDK/CloudPushSDK.h>

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@property (nonatomic, copy)NSArray *aliasArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;

    [self loadDataToRefreshList];
}

- (IBAction)limitNoteAction:(id)sender {
    [CustomAlertView showLimitNoteAlertView];
}

- (void)loadDataToRefreshList {
    dispatch_group_t group = dispatch_group_create();

    // load alias data
    dispatch_group_enter(group);
    [CloudPushSDK listAliases:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSString *dataString = (NSString *)res.data;
            if (dataString.length > 0) {
                self.aliasArray = [dataString componentsSeparatedByString:@","];
            } else {
                self.aliasArray = @[];
            }
        }
        dispatch_group_leave(group);
    }];

    // refresh list
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.settingTableView reloadData];
    });
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SettingAliasTableViewCell *cell = [[SettingAliasTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingAliasTableViewCell"];
        [cell setAlias:self.aliasArray];
        cell.addHandle = ^{
            [CustomAlertView showInputAlert:AlertInputTypeBindAlias handle:^(NSString * _Nonnull inputString) {
                [CloudPushSDK addAlias:inputString withCallback:^(CloudPushCallbackResult *res) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (res.success) {
                            [CustomToastUtil showToastWithMessage:@"别名添加成功！"];
                            [self loadDataToRefreshList];
                        } else {
                            [CustomToastUtil showToastWithMessage:@"别名添加失败！"];
                        }
                    });
                }];
            }];
        };
        cell.deleteHandle = ^(NSString * _Nonnull alias) {
            [CloudPushSDK removeAlias:alias withCallback:^(CloudPushCallbackResult *res) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (res.success) {
                        [CustomToastUtil showToastWithMessage:@"别名删除成功！"];
                        [self loadDataToRefreshList];
                    } else {
                        [CustomToastUtil showToastWithMessage:@"别名删除失败！"];
                    }
                });
            }];
        };
        return cell;
    }

    SettingSingleCellType cellType = SettingSingleCellTypeAccount;
    if (indexPath.section == 2) {
        cellType = SettingSingleCellTypeBadgeNumber;
    }
    SettingSingleTableViewCell *cell = [SettingSingleTableViewCell cellWithType:cellType];
    return cell;
}

#pragma mark - lazy load

- (NSArray *)aliasArray {
    if (!_aliasArray) {
        _aliasArray = [NSArray array];
    }
    return _aliasArray;
}

@end
