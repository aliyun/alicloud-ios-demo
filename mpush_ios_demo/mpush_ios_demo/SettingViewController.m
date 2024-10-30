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
#import "SettingAddTagViewController.h"

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
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        NSArray *indexPaths = @[indexPath];

        [self.settingTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    });
}

- (IBAction)limitNoteAction:(id)sender {
    [CustomAlertView showLimitNoteAlertView];
}

- (void)addTag {
    SettingAddTagViewController *addTagViewController = [[[NSBundle mainBundle] loadNibNamed:@"SettingAddTagViewController" owner:self options:nil] firstObject];
    addTagViewController.aliasArray = self.aliasArray;
    __weak typeof(self) weakSelf = self;
    addTagViewController.addHandle = ^(SettingTag * _Nonnull tag) {
        __strong typeof(self) strongSelf = weakSelf;

        NSString *key;
        BOOL shouldInsertToDB = NO;

        switch (tag.tagType) {
            case 1:
                key = @"device";
                break;
            case 2:
                key = @"account";
                shouldInsertToDB = YES;
                break;
            case 3:
                key = @"alias";
                shouldInsertToDB = YES;
                break;
            default:
                return; // Exit early for unhandled cases
        }

        // Update the tags data
        NSMutableArray *tagsArr = [strongSelf.tagsData[key] mutableCopy];
        [tagsArr addObject:tag];
        [strongSelf.tagsData setObject:tagsArr.copy forKey:key];

        // Insert to database if needed
        if (shouldInsertToDB) {
            SQLiteManager *manager = [[SQLiteManager alloc] init];
            [manager insertTag:tag];
        }

        [strongSelf refreshTableViewCellFor:0];
    };
    [self presentViewController:addTagViewController animated:YES completion:nil];
}

- (void)deleteTag:(SettingTag *)tag {
    [CloudPushSDK unbindTag:tag.tagType withTags:@[tag.tagName] withAlias:tag.tagAlias withCallback:^(CloudPushCallbackResult *res) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (res.success) {
                NSLog(@"删除的是：%@",tag.tagName);
                [CustomToastUtil showToastWithMessage:@"标签删除成功！"];
                NSMutableArray *tempArr;
                switch (tag.tagType) {
                    case 1:
                    {
                        tempArr = [self.tagsData[@"device"] mutableCopy];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tagName != %@", tag.tagName];
                        self.tagsData[@"device"] = [tempArr filteredArrayUsingPredicate:predicate];
                    }
                        break;
                    case 2:
                    {
                        tempArr = [self.tagsData[@"account"] mutableCopy];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tagName != %@", tag.tagName];
                        self.tagsData[@"account"] = [tempArr filteredArrayUsingPredicate:predicate];
                    }
                        break;
                    case 3:
                    {
                        tempArr = [self.tagsData[@"alias"] mutableCopy];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tagName != %@", tag.tagName];
                        self.tagsData[@"alias"] = [tempArr filteredArrayUsingPredicate:predicate];
                    }
                        break;
                    default:
                        return;
                }
                [self refreshTableViewCellFor:0];
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
                    [self.aliasArray addObject:inputString];
                    [self refreshTableViewCellFor:1];
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
                if ([self.aliasArray containsObject:alias]) {
                    [self.aliasArray removeObject:alias];
                }
                [self refreshTableViewCellFor:1];
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
