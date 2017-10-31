//
//  ViewController.m
//  hotfix-ios-demo
//
//  Created by junmo on 2017/10/19.
//  Copyright © 2017年 junmo. All rights reserved.
//

#import <AlicloudHotFixDebug/AlicloudHotFixDebug.h>

#import "ViewController.h"
#import <AlicloudHotFix/AlicloudHotFix.h>
#import "TestClass.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

static NSArray *tableViewGroupNames;
static NSArray *tableViewCellTitleInSection;

@implementation ViewController

+ (void)initialize {
    tableViewGroupNames = @[ @"补丁测试", @"补丁加载", @"补丁调试工具" ];
    tableViewCellTitleInSection = @[
                                    @[ @"补丁加载测试" ],
                                    @[ @"拉取补丁", @"删除下载补丁" ],
                                    @[ @"加载本地补丁文件", @"二维码扫描" ]
                                    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)showAlert:(NSString *)title content:(NSString *)content {
    if ([NSThread isMainThread]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        });
    }
}

#pragma mark TableView 数据源设置

/* Section Num */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableViewGroupNames.count;
}

/* Cell Num Each Section */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[tableViewCellTitleInSection objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"cellId-%ld-%ld", (long)indexPath.section, (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.textLabel.text = [self cellTitleForIndexPath:indexPath];
    return cell;
}

#pragma mark TableView 代理设置

/* Section Header Title */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return tableViewGroupNames[section];
}

/* Click Cell */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellTitle = [self cellTitleForIndexPath:indexPath];
    if ([cellTitle isEqualToString:@"拉取补丁"]) {
        [self onLoadPatchClick];
    } else if ([cellTitle isEqualToString:@"补丁加载测试"]) {
        [self onPatchTestClick];
    } else if ([cellTitle isEqualToString:@"删除下载补丁"]) {
        [self onCleanPatchClick];
    } else if ([cellTitle isEqualToString:@"二维码扫描"]) {
        [self onQrCodeClick];
    } else if ([cellTitle isEqualToString:@"加载本地补丁文件"]) {
        [self onLoadLocalPatchFileClick];
    }
}

- (NSString *)cellTitleForIndexPath:(NSIndexPath *)indexPath {
    return [[tableViewCellTitleInSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (void)onPatchTestClick {
    TestClass *testClass = [[TestClass alloc] init];
    [self showAlert:@"修复测试" content:[testClass output]];
}

- (void)onLoadPatchClick {
    [[AlicloudHotFixService sharedInstance] loadPatch:^(BOOL res, id data, NSError *error) {
        if (res) {
            NSLog(@"Load patch success.");
        } else {
            NSLog(@"Load patch failed, error: %@", error);
        }
    }];
}

- (void)onCleanPatchClick {
    [[AlicloudHotFixService sharedInstance] cleanPatch];
}

- (void)onQrCodeClick {
    [AlicloudHotFixDebugService showDebug:self];
}

- (void)onLoadLocalPatchFileClick {
    NSString *patchFilePath = [[NSBundle mainBundle] pathForResource:@"fix" ofType:@"lua"];
    [AlicloudHotFixDebugService loadLocalPachFile:patchFilePath];
}

@end
