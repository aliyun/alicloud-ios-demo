//
//  LZLSettingsViewController.m
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/3/31.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "LZLSettingsViewController.h"
#import <AliCloudPush/AliCloudPush.h>

@interface LZLSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userAccount;
@property (weak, nonatomic) IBOutlet UITextField *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *userAlias;

@end

@implementation LZLSettingsViewController

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

/**
 *  绑定账号
 *
 *  @param sender
 */
- (IBAction)userBindAccount:(id)sender {
    if (self.userAccount.text.length > 0) {
        // 用户按下按钮&&输入了准备绑定的帐户名称
        [CloudPushSDK bindAccount:self.userAccount.text withCallback:^(CloudPushCallbackResult *res) {
            if (res.success) {
                NSLog(@"==================> 绑定账号成功");
                
                // 切回主线程，防止crash
                [MsgToolBox showAlert:@"温馨提示" content:@"账号绑定成功！"];
                [self clearInput];
                
                // 持久化已绑定的数据
                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                [userDefaultes setObject:self.userAccount.text forKey:@"bindAccount"];
                [userDefaultes synchronize];
            } else {
                NSLog(@"==================> 绑定账号失败");
                [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"账号绑定失败, error: %@", res.error]];
            }
        }];
        
        [self.userAccount resignFirstResponder];
    } else {
        [MsgToolBox showAlert:@"温馨提示" content:@"请输入帐户名！"];
    }
}

/**
 *  解绑账号
 *
 *  @param sender
 */
- (IBAction)antiBindAccount:(id)sender {
    [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"解绑账号成功");
            
            // 切回主线程，防止crash
            [MsgToolBox showAlert:@"温馨提示" content:@"账号解绑成功！"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self clearInput];
            });
            
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            [userDefaultes setObject:nil forKey:@"bindAccount"];
            [userDefaultes synchronize];
            
        } else {
            NSLog(@"解绑账号失败");
            [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"账号解绑失败, error: %@", res.error]];
        }
    }];
    [self.userAccount resignFirstResponder];
}

/**
 *  绑定设备标签
 *
 *  @param sender
 */
- (IBAction)userBindTagToDev:(id)sender {
    NSArray *tagArray = [self getTagArray];
    if (!tagArray) return;
    [CloudPushSDK bindTag:1 withTags:tagArray withAlias:nil withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"绑定设备标签成功");
            [MsgToolBox showAlert:@"温馨提示" content:@"设备标签绑定成功"];
            [self clearInput];
        } else {
            NSLog(@"绑定设备标签失败，错误: %@", res.error);
            [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"设备标签绑定失败, error: %@", res.error]];
        }
    }];
}

/**
 *  解绑设备标签
 *
 *  @param sender
 */
- (IBAction)userUnbindTagFromDev:(id)sender {
    NSArray *tagArray = [self getTagArray];
    if (!tagArray) return;
    [CloudPushSDK unbindTag:1 withTags:tagArray withAlias:nil withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"解绑设备标签成功");
            [MsgToolBox showAlert:@"温馨提示" content:@"解绑设备标签成功"];
            [self clearInput];
        } else {
            NSLog(@"解绑设备标签失败，错误: %@", res.error);
            [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"解绑设备标签失败, error: %@", res.error]];
        }
    }];
}

/**
 *  绑定账号标签
 *
 *  @param sender
 */
- (IBAction)userBindTagToAccount:(id)sender {
    NSArray *tagArray = [self getTagArray];
    if (!tagArray) return;
    [CloudPushSDK bindTag:2 withTags:tagArray withAlias:nil withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"绑定账号标签成功");
            [MsgToolBox showAlert:@"温馨提示" content:@"账号标签绑定成功"];
            [self clearInput];
        } else {
            NSLog(@"绑定账号标签失败，错误: %@", res.error);
            [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"账号标签绑定失败, error: %@", res.error]];
        }
    }];
}

/**
 *  解绑账号标签
 *
 *  @param sender
 */
- (IBAction)userUnbindTagFromAccount:(id)sender {
    NSArray *tagArray = [self getTagArray];
    if (!tagArray) return;
    [CloudPushSDK unbindTag:2 withTags:tagArray withAlias:nil withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"解绑账号标签成功");
            [MsgToolBox showAlert:@"温馨提示" content:@"解绑账号标签成功"];
            [self clearInput];
        } else {
            NSLog(@"解绑账号标签失败，错误: %@", res.error);
            [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"解绑账号标签失败, error: %@", res.error]];
        }
    }];
}

/**
 *  绑定别名标签
 *
 *  @param sender
 */
- (IBAction)userBindTagToAlias:(id)sender {
    NSArray *tagArray = [self getTagArray];
    if (!tagArray) return;
    NSString *aliasString = _userAlias.text;
    if (aliasString.length == 0) {
        [MsgToolBox showAlert:@"温馨提示" content:@"请输入别名"];
        return;
    }
    [CloudPushSDK bindTag:3 withTags:tagArray withAlias:aliasString withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"绑定别名标签成功");
            [MsgToolBox showAlert:@"温馨提示" content:@"别名标签绑定成功"];
            [self clearInput];
        } else {
            NSLog(@"绑定别名标签失败，错误: %@", res.error);
            [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"别名标签绑定失败, error: %@", res.error]];
        }
    }];
}

/**
 *  解绑别名标签
 *
 *  @param sender
 */
- (IBAction)userUnbindTagFromAlias:(id)sender {
    NSArray *tagArray = [self getTagArray];
    if (!tagArray) return;
    NSString *aliasString = _userAlias.text;
    if (aliasString.length == 0) {
        [MsgToolBox showAlert:@"温馨提示" content:@"请输入别名"];
        return;
    }
    [CloudPushSDK unbindTag:3 withTags:tagArray withAlias:aliasString withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"解绑别名标签成功");
            [MsgToolBox showAlert:@"温馨提示" content:@"别名标签解绑成功"];
            [self clearInput];
        } else {
            NSLog(@"解绑别名标签失败，错误: %@", res.error);
            [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"解绑别名标签绑定失败, error: %@", res.error]];
        }
    }];
}

/**
 *  查询设备标签
 *
 *  @param sender
 */
- (IBAction)userListTags:(id)sender {
    [CloudPushSDK listTags:1 withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"查询设备标签成功：%@", res.data);
            [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"查询设备标签成功：%@", res.data]];
        } else {
            NSLog(@"查询设备标签失败，错误: %@", res.error);
            [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"查询设备标签失败, error: %@", res.error]];
        }
    }];
}

/**
 *  添加设备别名
 *
 *  @param sender
 */
- (IBAction)userAddAlias:(id)sender {
    NSString *aliasString = _userAlias.text;
    if (aliasString.length == 0) {
        [MsgToolBox showAlert:@"温馨提示" content:@"请输入别名"];
        return;
    }
    [CloudPushSDK addAlias:aliasString withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"添加设备别名成功");
            [MsgToolBox showAlert:@"温馨提示" content:@"添加设备别名成功"];
            [self clearInput];
        } else {
            NSLog(@"添加设备别名失败，错误: %@", res.error);
            [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"添加设备别名失败, error: %@", res.error]];
        }
    }];
}

/**
 *  删除设备别名
 *
 *  @param sender
 */
- (IBAction)userRemoveAlias:(id)sender {
    NSString *aliasString = _userAlias.text;
    if (aliasString.length == 0) {
        NSLog(@"删除全部别名");
    }
    [CloudPushSDK removeAlias:aliasString withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"删除设备别名成功");
            [MsgToolBox showAlert:@"温馨提示" content:@"删除设备别名成功"];
        } else {
            NSLog(@"删除设备别名失败，错误: %@", res.error);
            [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"删除设备别名失败, error: %@", res.error]];
        }
    }];
}

/**
 *  查询设备别名
 *
 *  @param sender
 */
- (IBAction)userListAliases:(id)sender {
    [CloudPushSDK listAliases:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"查询设备别名成功：%@", res.data);
            [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"查询设备别名成功：%@", res.data]];
        } else {
            NSLog(@"查询设备别名失败，错误: %@", res.error);
            [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"查询设备别名失败, error: %@", res.error]];
        }
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (void) alertMsg:(NSString *)title content:(NSString *)content {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userAccount.delegate = self;
    self.userLabel.delegate = self;
    self.userAlias.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
