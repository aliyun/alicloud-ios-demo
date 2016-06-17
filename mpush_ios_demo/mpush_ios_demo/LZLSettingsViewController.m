//
//  LZLSettingsViewController.m
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/3/31.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "LZLSettingsViewController.h"
#import <CloudPushSDK/CloudPushSDK.h>

@interface LZLSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userAccount;
@property (weak, nonatomic) IBOutlet UITextField *userLabel;

@end

@implementation LZLSettingsViewController

// 点击背景，键盘隐藏
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// 点击键盘return，键盘隐藏
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 用户按下绑定账号按钮
- (IBAction)userBindAccount:(id)sender {
    if (self.userAccount.text.length > 0) {
        //用户按下按钮&&输入了准备绑定的帐户名称
        [CloudPushSDK bindAccount:self.userAccount.text withCallback:^(CloudPushCallbackResult *res) {
            if (res.success) {
                NSLog(@"==================> 绑定账号成功");
                
                // 切回主线程，防止crash
                [MsgToolBox showAlert:@"温馨提示" content:@"账号绑定成功！"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self userAccount].text = @"";
                });

                //持久化已绑定的数据
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

#pragma mark 用户按下解绑账号按钮
- (IBAction)antiBindAccount:(id)sender {
    if (self.userAccount.text.length > 0) {
        //用户按下按钮&&输入了准备绑定的帐户名称
        [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
            if (res.success) {
                NSLog(@"==================> 解绑账号成功");
                
                // 切回主线程，防止crash
                [MsgToolBox showAlert:@"温馨提示" content:@"账号解绑成功！"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self userAccount].text = @"";
                });
                
                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                [userDefaultes setObject:nil forKey:@"bindAccount"];
                [userDefaultes synchronize];
                
            } else {
                NSLog(@"==================> 解绑账号失败");
                [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"账号解绑失败, error: %@", res.error]];
            }
        }];
        [self.userAccount resignFirstResponder];
    } else {
        [MsgToolBox showAlert:@"温馨提示" content:@"请输入帐户名！"];
    }
}

// User bind tag.
- (IBAction)userBindTag:(id)sender {
    if (self.userLabel.text.length > 0) {
            [CloudPushSDK addTag:self.userLabel.text withCallback:^(CloudPushCallbackResult *res) {
            if (res.success) {
                NSLog(@"==================> 绑定标签成功");
                
                // 切回主线程，防止crash
                [MsgToolBox showAlert:@"温馨提示" content:@"标签绑定成功！"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self userLabel].text = @"";
                });
            } else {
                NSLog(@"==================> 绑定标签失败");
                [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"标签绑定失败, error: %@", res.error]];
            }
        }];
        [self.userLabel resignFirstResponder];
    } else {
        [MsgToolBox showAlert:@"温馨提示" content:@"请输入标签！"];
    }
}

// User Anti-bind tag.
- (IBAction)userAntiBindTag:(id)sender {
    if (self.userLabel.text.length > 0) {
        [CloudPushSDK removeTag:self.userLabel.text withCallback:^(CloudPushCallbackResult *res) {
            if (res.success) {
                NSLog(@"==================> 删除标签成功");
                
                // 切回主线程，防止crash
                [MsgToolBox showAlert:@"温馨提示" content:@"标签删除成功！"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self userLabel].text = @"";
                });
            } else {
                NSLog(@"==================> 绑定删除失败");
                [MsgToolBox showAlert:@"温馨提示" content:[NSString stringWithFormat:@"标签解绑失败, error: %@", res.error]];
            }
        }];
        [self.userLabel resignFirstResponder];
    } else {
        [MsgToolBox showAlert:@"温馨提示" content:@"请输入标签！"];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {}

- (void) alertMsg:(NSString *)title content:(NSString *)content {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userAccount.delegate = self;
    self.userLabel.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
