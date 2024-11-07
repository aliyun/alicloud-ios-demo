//
//  ShowAllTagsViewController.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/11/1.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "ShowAllTagsViewController.h"
#import "TagsCollectionViewCell.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "CustomToastUtil.h"
#import "SQLiteManager.h"
#import "SettingAddTagViewController.h"
#import "CustomAlertView.h"

@interface ShowAllTagsViewController ()<UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *tagsCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation ShowAllTagsViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;

    self.tagsCollectionView.dataSource = self;
    [self.tagsCollectionView registerClass:[TagsCollectionViewCell class] forCellWithReuseIdentifier:@"TagsCollectionViewCell"];

    if (self.isAlias) {
        self.titleLabel.text = @"别名";
        [self.addButton setTitle:@"添加别名" forState:UIControlStateNormal];
    } else {
        SettingTag *tag = self.dataArray.firstObject;
        if (tag.tagType == 2) {
            self.titleLabel.text = @"账号标签";
        } else if (tag.tagType == 3) {
            self.titleLabel.text = @"别名标签";
        }
    }
}

- (NSArray *)getAllAlias {
    __block NSArray *aliasArray = [NSArray array];
    // 创建一个信号量，初始值为 0
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [CloudPushSDK listAliases:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSString *dataString = (NSString *)res.data;
            if (dataString.length > 0) {
                aliasArray = [dataString componentsSeparatedByString:@","];
            }
        }
        // 无论成功还是失败，都要释放信号量
        dispatch_semaphore_signal(semaphore);
    }];

    // 等待信号量，直到信号量被释放
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    return aliasArray;
}


#pragma mark - action

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addTag:(id)sender {
    if (self.isAlias) {
        __weak typeof(self) weakSelf = self;
        [CustomAlertView showInputAlert:AlertInputTypeBindAlias handle:^(NSString * _Nonnull inputString) {
            [CloudPushSDK addAlias:inputString withCallback:^(CloudPushCallbackResult *res) {
                __strong typeof(self) strongSelf = weakSelf;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (res.success) {
                        [CustomToastUtil showToastWithMessage:@"别名添加成功！"];
                        NSMutableArray *tempArray = strongSelf.dataArray.mutableCopy;
                        [tempArray addObject:inputString];
                        strongSelf.dataArray = tempArray.copy;
                        [strongSelf.tagsCollectionView reloadData];
                    } else {
                        [CustomToastUtil showToastWithMessage:@"别名添加失败！"];
                    }
                });
            }];
        }];
    } else {
        SettingAddTagViewController *addTagViewController = [[[NSBundle mainBundle] loadNibNamed:@"SettingAddTagViewController" owner:self options:nil] firstObject];

        SettingTag *tag = self.dataArray.firstObject;
        [addTagViewController setSeletedTagType:tag.tagType];

        if (tag.tagType == 3) {
            addTagViewController.aliasArray = [self getAllAlias];
        }

        __weak typeof(self) weakSelf = self;
        addTagViewController.addHandle = ^(SettingTag * _Nonnull tag) {
            __strong typeof(self) strongSelf = weakSelf;
            NSMutableArray *tempArray = strongSelf.dataArray.mutableCopy;
            [tempArray addObject:tag];
            strongSelf.dataArray = tempArray.copy;

            if (tag.tagType == 2 || tag.tagType == 3) {
                SQLiteManager *manager = [[SQLiteManager alloc] init];
                [manager insertTag:tag];
            }

            [strongSelf.tagsCollectionView reloadData];
        };
        [self presentViewController:addTagViewController animated:YES completion:nil];
    }
}

- (void)deleteTag:(SettingTag *)tag {
    [CloudPushSDK unbindTag:tag.tagType withTags:@[tag.tagName] withAlias:tag.tagAlias withCallback:^(CloudPushCallbackResult *res) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (res.success) {
                [CustomToastUtil showToastWithMessage:@"标签删除成功！"];
                NSMutableArray *tempArray;
                tempArray = [self.dataArray mutableCopy];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tagName != %@", tag.tagName];
                self.dataArray = [tempArray filteredArrayUsingPredicate:predicate];
                [self.tagsCollectionView reloadData];
                
                if (tag.tagType != 1) {
                    SQLiteManager *manager = [[SQLiteManager alloc] init];
                    [manager removeTag:tag];
                }
            } else {
                [CustomToastUtil showToastWithMessage:@"标签删除失败！"];
            }
        });
    }];
}

- (void)deleteAlias:(NSString *)alias {
    [CloudPushSDK removeAlias:alias withCallback:^(CloudPushCallbackResult *res) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (res.success) {
                [CustomToastUtil showToastWithMessage:@"别名删除成功！"];

                if ([self.dataArray containsObject:alias]) {
                    NSMutableArray *tempArray = [self.dataArray mutableCopy];
                    [tempArray removeObject:alias];
                    self.dataArray = [tempArray copy];
                }
                [self.tagsCollectionView reloadData];
            } else {
                [CustomToastUtil showToastWithMessage:@"别名删除失败！"];
            }
        });
    }];
}

#pragma mark - UICollectionView dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TagsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagsCollectionViewCell" forIndexPath:indexPath];

    if (self.isAlias) {
        NSString *alias = self.dataArray[indexPath.row];
        [cell setAlias:alias];
    } else {
        SettingTag *tag = self.dataArray[indexPath.row];
        [cell setTag:tag];
    }
    
    cell.deleteAliasHandle = ^(NSString * _Nonnull alias) {
        [self deleteAlias:alias];
    };

    cell.deleteHandle = ^(SettingTag * _Nonnull tag) {
        [self deleteTag:tag];
    };

    return cell;
}

@end
