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
#import "SettingTagTableViewCell.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "SQLiteManager.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@property (nonatomic, strong)NSMutableArray *aliasArray;

@property (nonatomic, strong)NSMutableDictionary *tagsData;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;

    [self loadDataToRefreshList];
}

- (void)loadDataToRefreshList {
    dispatch_group_t group = dispatch_group_create();

    // load tag data
    // device tags 
    dispatch_group_enter(group);
    [CloudPushSDK listTags:1 withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSString *dataString = (NSString *)res.data;
            if (dataString.length > 0) {
                NSArray *tagsArr = [dataString componentsSeparatedByString:@","];
                NSMutableArray *settingTagsArray = [NSMutableArray array];
                for (NSString *tagName in tagsArr) {
                    SettingTag *tag = [[SettingTag alloc] init];
                    tag.tagName = tagName;
                    tag.tagType = 1;
                    [settingTagsArray addObject:tag];
                }
                [self.tagsData setObject:settingTagsArray.copy forKey:@"device"];
            } else {
                [self.tagsData setObject:@[] forKey:@"device"];
            }
        }
        dispatch_group_leave(group);
    }];

    // load aliasTags and accountTags
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SQLiteManager *manager = [[SQLiteManager alloc] init];

        NSArray *aliasTags = [manager allAliasTags].copy;
        NSArray *accountTags = [manager allAccountTags].copy;
        [self.tagsData setObject:aliasTags forKey:@"alias"];
        [self.tagsData setObject:accountTags forKey:@"account"];
        dispatch_group_leave(group);
    });

    // load alias data
    dispatch_group_enter(group);
    [CloudPushSDK listAliases:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSString *dataString = (NSString *)res.data;
            if (dataString.length > 0) {
                self.aliasArray = [dataString componentsSeparatedByString:@","].mutableCopy;
            } else {
                self.aliasArray = [NSMutableArray array];
            }
        }
        dispatch_group_leave(group);
    }];

    // refresh list
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.settingTableView reloadData];
    });
}

- (void)refreshTableViewCellFor:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:index];
    NSArray *indexPaths = @[indexPath];

    [self.settingTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)limitNoteAction:(id)sender {
    [CustomAlertView showLimitNoteAlertView];
}

- (void)addTag {
   [CloudPushSDK bindTag:1 withTags:@[@"测试专用",@"测试专用1",@"测试专用2",@"测试专用3",@"测试专用4",@"测试专用5",@"测试专用6",@"测试专用7",@"测试专用8",@"测试专用9",@"测试专用10"] withAlias:nil withCallback:^(CloudPushCallbackResult *res) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (res.success) {
                [CustomToastUtil showToastWithMessage:@"标签添加成功！"];
                [self loadDataToRefreshList];
            } else {
                [CustomToastUtil showToastWithMessage:@"标签添加失败！"];
            }
        });
    }];
}

- (void)deleteTag:(SettingTag *)tag {
    [CloudPushSDK unbindTag:tag.tagType withTags:@[tag.tagName] withAlias:tag.tagAlias withCallback:^(CloudPushCallbackResult *res) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (res.success) {
                NSLog(@"删除的是：%@",tag.tagName);
                [CustomToastUtil showToastWithMessage:@"标签删除成功！"];
                [self loadDataToRefreshList];
            } else {
                [CustomToastUtil showToastWithMessage:@"标签删除失败！"];
            }
        });
    }];
}

- (void)showAllTags:(int)tagType {

}

- (void)addAlias {
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
}

- (void)deleteAlias:(NSString *)alias {
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
}

- (void)showAllAlias {

}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
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
        return[self setupTagCell];
    }

    if (indexPath.section == 1) {
        SettingAliasTableViewCell *cell = [[SettingAliasTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingAliasTableViewCell"];
        [cell setAlias:self.aliasArray];
        __weak typeof(self) weakSelf = self;
        cell.addHandle = ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf addAlias];
        };
        cell.deleteHandle = ^(NSString * _Nonnull alias) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf deleteAlias:alias];
        };
        cell.showAllHandle = ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf showAllAlias];
        };
        return cell;
    }

    SettingSingleCellType cellType = SettingSingleCellTypeAccount;
    if (indexPath.section == 3) {
        cellType = SettingSingleCellTypeBadgeNumber;
    }
    SettingSingleTableViewCell *cell = [SettingSingleTableViewCell cellWithType:cellType];
    return cell;
}

- (SettingTagTableViewCell *)setupTagCell {
    SettingTagTableViewCell *cell = [[SettingTagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingTagTableViewCell"];
    __weak typeof(self) weakSelf = self;
    cell.addHandle = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf addTag];
    };
    cell.deleteHandle = ^(SettingTag * _Nonnull tag) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf deleteTag:tag];
    };
    cell.showAllHandle = ^(int tagType) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showAllTags:tagType];
    };
    [cell setTagsData:self.tagsData];
    NSLog(@"赋值--%@",self.tagsData);
    return cell;
}

#pragma mark - lazy load

- (NSMutableArray *)aliasArray {
    if (!_aliasArray) {
        _aliasArray = [NSMutableArray array];
    }
    return _aliasArray;
}

- (NSMutableDictionary *)tagsData {
    if (!_tagsData) {
        _tagsData = [NSMutableDictionary dictionaryWithDictionary:@{@"device":@[],@"alias":@[],@"account":@[]}];
    }
    return _tagsData;
}

@end
