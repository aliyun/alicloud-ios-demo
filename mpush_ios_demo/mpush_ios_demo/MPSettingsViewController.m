//
//  MPSettingsViewController.m
//
//  Created by junmo on 17/8/31.
//  Copyright (c) 2017年 alibaba. All rights reserved.
//

#import "MPSettingsViewController.h"
#import <CloudPushSDK/CloudPushSDK.h>

static NSArray *tableViewGroupNames;
static NSArray *tableViewCellTitleInSection;

@interface MPSettingsViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userAccount;
@property (weak, nonatomic) IBOutlet UITextField *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *userAlias;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *logText;

@end

@implementation MPSettingsViewController

// 点击背景，键盘隐藏
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// 点击键盘return，键盘隐藏
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/**
 *  获取标签数组
 *
 *  @return
 */
- (NSArray *)getTagArray {
    NSString *tagString = _userLabel.text;
    if (tagString.length > 0) {
        NSArray *tagArray = [tagString componentsSeparatedByString:@" "];
        return tagArray;
    } else {
        [MsgToolBox showAlert:@"温馨提示" content:@"请输入标签！"];
        return nil;
    }
}

- (void)clearInput {
    dispatch_async(dispatch_get_main_queue(), ^{
        _userAccount.text = @"";
        _userLabel.text = @"";
        _userAlias.text = @"";
    });
}

- (void)bindAccount:(NSString *)account {
    if (account == nil || account.length == 0) {
        return;
    }
    [CloudPushSDK bindAccount:account withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            [userDefaultes setObject:account forKey:@"bindAccount"];
            [userDefaultes synchronize];
            [self showLog:@"账号绑定成功"];
        } else {
            [self showLog:[NSString stringWithFormat:@"账号绑定失败，错误: %@", res.error]];
        }
    }];
}

- (void)unbindAccount {
    [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            [userDefaultes setObject:nil forKey:@"bindAccount"];
            [userDefaultes synchronize];
            [self showLog:@"账号解绑成功"];
        } else {
            [self showLog:[NSString stringWithFormat:@"账号解绑失败，错误: %@", res.error]];
        }
    }];
}

- (void)bindTagForDevice:(NSString *)tagStr {
    NSArray *tagArray = [tagStr componentsSeparatedByString:@" "];
    [CloudPushSDK bindTag:1 withTags:tagArray withAlias:nil withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            [self showLog:@"设备标签绑定成功"];
        } else {
            [self showLog:[NSString stringWithFormat:@"设备标签绑定失败，错误: %@", res.error]];
        }
    }];
}

- (void)unbindTagForDevice:(NSString *)tagStr {
    NSArray *tagArray = [tagStr componentsSeparatedByString:@" "];
    [CloudPushSDK unbindTag:1 withTags:tagArray withAlias:nil withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            [self showLog:@"设备标签解绑成功"];
        } else {
            [self showLog:[NSString stringWithFormat:@"设备标签解绑失败，错误: %@", res.error]];
        }
    }];
}

- (void)listTagForDevice {
    [CloudPushSDK listTags:1 withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            [self showLog:[NSString stringWithFormat:@"设备标签查询成功: %@", res.data]];
        } else {
            [self showLog:[NSString stringWithFormat:@"设备标签查询失败，错误: %@", res.error]];
        }
    }];
}

- (void)addAlias:(NSString *)alias {
    [CloudPushSDK addAlias:alias withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            [self showLog:@"别名添加成功"];
        } else {
            [self showLog:[NSString stringWithFormat:@"别名添加失败，错误: %@", res.error]];
        }
    }];
}

- (void)removeAlias:(NSString *)alias {
    [CloudPushSDK removeAlias:alias withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            [self showLog:@"别名添加成功"];
        } else {
            [self showLog:[NSString stringWithFormat:@"别名添加失败，错误: %@", res.error]];
        }
    }];
}

- (void)listAlias {
    [CloudPushSDK listAliases:^(CloudPushCallbackResult *res) {
        if (res.success) {
            [self showLog:[NSString stringWithFormat:@"别名查询成功: %@", res.data]];
        } else {
            [self showLog:[NSString stringWithFormat:@"别名查询失败，错误: %@", res.error]];
        }
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {}

- (void) alertMsg:(NSString *)title content:(NSString *)content {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTextFiled];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)initialize {
    
    tableViewGroupNames = @[
                            @"账号",
                            @"标签",
                            @"别名"
                            ];
    
    tableViewCellTitleInSection = @[
                                    @[ @"账号绑定", @"账号解绑", @"账号查询" ],
                                    @[ @"设备标签绑定", @"设备标签解绑", @"设备标签查询" ],
                                    @[ @"别名添加", @"别名删除", @"别名查询" ]
                                    ];
}

- (void)initTextFiled {
    self.logText = [[UITextView alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width - 20, 350)];
    [self.logText.layer setBorderWidth:1];
    self.logText.userInteractionEnabled = NO;
    [self.view addSubview:self.logText];
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, self.view.frame.size.height - 450) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)showInputViewWithTitle:(NSString *)title message:(NSString *)message type:(NSInteger)type {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"cancel"
                                          otherButtonTitles:@"ok", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        return;
    }
    NSString *alertTitle = alertView.title;
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSString *text = textField.text;
    if (text == nil || text.length == 0) {
        return;
    }
    if ([alertTitle isEqualToString:@"账号绑定"]) {
        [self bindAccount:text];
    } else if ([alertTitle isEqualToString:@"设备标签绑定"]) {
        [self bindTagForDevice:text];
    } else if ([alertTitle isEqualToString:@"设备标签解绑"]) {
        [self unbindTagForDevice:text];
    } else if ([alertTitle isEqualToString:@"别名添加"]) {
        [self addAlias:text];
    } else if ([alertTitle isEqualToString:@"别名删除"]) {
        [self removeAlias:text];
    }
}

- (void)showLog:(NSString *)text {
    NSLog(@"%@", text);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.logText.text = [self.logText.text stringByAppendingString:text];
        self.logText.text = [self.logText.text stringByAppendingString:@"\n"];
    });
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
    if ([cellTitle isEqualToString:@""]) {
        [self showInputViewWithTitle:cellTitle message:nil type:1];
    } else if ([cellTitle isEqualToString:@"账号解绑"]) {
        [self unbindAccount];
    } else if ([cellTitle isEqualToString:@"账号查询"]) {
    } else if ([cellTitle isEqualToString:@"设备标签绑定"]) {
        [self showInputViewWithTitle:cellTitle message:nil type:1];
    } else if ([cellTitle isEqualToString:@"设备标签解绑"]) {
        [self showInputViewWithTitle:cellTitle message:nil type:1];
    } else if ([cellTitle isEqualToString:@"设备标签查询"]) {
        [self listTagForDevice];
    } else if ([cellTitle isEqualToString:@"别名添加"]) {
        [self showInputViewWithTitle:cellTitle message:nil type:1];
    } else if ([cellTitle isEqualToString:@"别名删除"]) {
        [self showInputViewWithTitle:cellTitle message:nil type:1];
    } else if ([cellTitle isEqualToString:@"别名查询"]) {
        [self listAlias];
    }
}

- (NSString *)cellTitleForIndexPath:(NSIndexPath *)indexPath {
    return [[tableViewCellTitleInSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

@end
