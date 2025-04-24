//
//  SDKConfigViewController.m
//  apm_ios_demo
//
//  Created by Miracle on 2025/4/16.
//  Copyright © 2025 aliyun. All rights reserved.
//

#import "SDKConfigViewController.h"
#import "Macros.h"
#import "CommonTools.h"

@interface SDKConfigViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *appKeyTextfiled;

@property (weak, nonatomic) IBOutlet UITextField *appSecretTextfiled;

@property (weak, nonatomic) IBOutlet UITextField *appRsaTextfiled;

@property (weak, nonatomic) IBOutlet UISwitch *crashAnalysisSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *performanceSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *remoteLogSwitch;

@end

@implementation SDKConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchAndDisplayConfigs];

    // 设置输入框代理
    self.appKeyTextfiled.delegate = self;
    self.appSecretTextfiled.delegate = self;
    self.appRsaTextfiled.delegate = self;
}

- (void)fetchAndDisplayConfigs {
    NSString *appKey = (NSString *)[CommonTools userDefaultGet:kAppKey];
    NSString *appSecret = (NSString *)[CommonTools userDefaultGet:kAppSecret];
    NSString *appRsaSecret = (NSString *)[CommonTools userDefaultGet:kAppRsaSecret];
    NSArray *funtions = (NSArray *)[CommonTools userDefaultGet:kFunctions];

    if (!appKey || !appSecret || !appRsaSecret || !funtions) {
        return;
    }

    self.appKeyTextfiled.text = appKey;
    self.appSecretTextfiled.text = appSecret;
    self.appRsaTextfiled.text = appRsaSecret;

    [self.crashAnalysisSwitch setOn:NO];
    [self.performanceSwitch setOn:NO];
    [self.remoteLogSwitch setOn:NO];

    NSDictionary *switchMaps = @{
        @"EAPMCrashAnalysis" : self.crashAnalysisSwitch,
        @"EAPMPerformance" : self.performanceSwitch,
        @"EAPMRemoteLog" : self.remoteLogSwitch
    };

    for (NSString *key in switchMaps) {
        UISwitch *functionSwitch = switchMaps[key];
        [functionSwitch setOn:NO];
    }

    for (NSString *function in funtions) {
        UISwitch *functionSwitch = switchMaps[function];
        if (functionSwitch) {
            [functionSwitch setOn:YES];
        }
    }

}

#pragma mark - action

- (IBAction)saveAction:(id)sender {
    if ([self textFiledIsEmpty:self.appKeyTextfiled]) {
        [self showAlertWithMessage:@"appKey不能为空"];
        return;
    }

    if ([self textFiledIsEmpty:self.appSecretTextfiled]) {
        [self showAlertWithMessage:@"appSecret不能为空"];
        return;
    }

    if ([self textFiledIsEmpty:self.appRsaTextfiled]) {
        [self showAlertWithMessage:@"appRsaSecret不能为空"];
        return;
    }

    if (!self.crashAnalysisSwitch.isOn && !self.performanceSwitch.isOn && !self.remoteLogSwitch.isOn) {
        [self showAlertWithMessage:@"至少选择一个功能"];
        return;
    }

    NSString *appkey = [self.appKeyTextfiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *appSecret = [self.appSecretTextfiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *appRsaSecret = [self.appRsaTextfiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [CommonTools userDefaultSetObject:appkey forKey:kAppKey];
    [CommonTools userDefaultSetObject:appSecret forKey:kAppSecret];
    [CommonTools userDefaultSetObject:appRsaSecret forKey:kAppRsaSecret];

    NSMutableArray *functions = [NSMutableArray array];
    if (self.crashAnalysisSwitch.isOn) {
        [functions addObject:@"EAPMCrashAnalysis"];
    }

    if (self.performanceSwitch.isOn) {
        [functions addObject:@"EAPMPerformance"];
    }

    if (self.remoteLogSwitch.isOn) {
        [functions addObject:@"EAPMRemoteLog"];
    }

    [CommonTools userDefaultSetObject:functions.copy forKey:kFunctions];

    // 退出APP
    exit(0);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - tools

- (BOOL)textFiledIsEmpty:(UITextField *)textFiled {
    if (textFiled.text == nil || [textFiled.text length] == 0) {
        return YES;
    }
    return NO;
}

/// 显示提示
- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

@end
