//
//  SettingAddTagViewController.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/28.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "SettingAddTagViewController.h"
#import "AddTagTypeButton.h"
#import "AliasListViewController.h"
#import "CustomToastUtil.h"
#import "MsgToolBox.h"
#import <CloudPushSDK/CloudPushSDK.h>

@interface SettingAddTagViewController ()
@property (weak, nonatomic) IBOutlet AddTagTypeButton *addDeviceTagButton;
@property (weak, nonatomic) IBOutlet AddTagTypeButton *addAliasTagButton;
@property (weak, nonatomic) IBOutlet AddTagTypeButton *addAccountTagButton;
@property (weak, nonatomic) IBOutlet UITextField *tagNameTextField;

@property (nonatomic, copy)NSString *alias;

@end

@implementation SettingAddTagViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self setupTypeButtonStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.addDeviceTagButton setName:@"设备标签" hasArrow:NO];
    [self.addAliasTagButton setName:@"别名标签" hasArrow:YES];
    [self.addAccountTagButton setName:@"账号标签" hasArrow:NO];
}

- (void)setupTypeButtonStatus {
    if (self.aliasArray.count <= 0) {
        [self.addAliasTagButton setDisable];
    }

    NSString *bindAccount = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_BINDACCOUNT];
    if (!bindAccount || bindAccount.length <= 0) {
        [self.addAccountTagButton setDisable];
    } else {
        [self.addAccountTagButton setValue:bindAccount];
    }
}

- (void)setSeletedTagType:(int)tagType {
    switch (tagType) {
        case 1:
            self.addDeviceTagButton.selected = YES;
            [self.addAliasTagButton setDisable];
            [self.addAccountTagButton setDisable];
            break;
        case 2:
            self.addAccountTagButton.selected = YES;
            [self.addAliasTagButton setDisable];
            [self.addDeviceTagButton setDisable];
            break;
        case 3:
            self.addAliasTagButton.selected = YES;
            [self.addAliasTagButton setValue:@"未选择别名"];
            [self.addAccountTagButton setDisable];
            [self.addDeviceTagButton setDisable];
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 点击空白处隐藏键盘
    [self.view endEditing:YES];
}

#pragma mark - action

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addDeviceTagAction:(id)sender {
    self.addDeviceTagButton.selected = YES;
    self.addAliasTagButton.selected = NO;
    self.addAccountTagButton.selected = NO;
}

- (IBAction)addAliasTagAction:(id)sender {
    AliasListViewController *aliasListViewController = [[UIStoryboard storyboardWithName:@"AliasListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"AliasListViewController"];
    aliasListViewController.aliasArray = self.aliasArray;
    __weak typeof(self) weakSelf = self;
    aliasListViewController.chooseHandle = ^(NSString * _Nonnull alias) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.addAliasTagButton setValue:alias];
        strongSelf.alias = alias;

        strongSelf.addAliasTagButton.selected = YES;
        strongSelf.addDeviceTagButton.selected = NO;
        strongSelf.addAccountTagButton.selected = NO;
    };
    [self presentViewController:aliasListViewController animated:YES completion:nil];
}

- (IBAction)addAccountTagAction:(id)sender {
    self.addAccountTagButton.selected = YES;
    self.addDeviceTagButton.selected = NO;
    self.addAliasTagButton.selected = NO;
}

- (IBAction)cancleAction:(id)sender {
    [self goBack:nil];
}

- (IBAction)confirmAction:(id)sender {
    if (self.tagNameTextField.text.length <= 0) {
        [MsgToolBox showAlert:@"" content:@"请输入要绑定的标签"];
        return;
    }

    if (!self.addDeviceTagButton.isSelected && !self.addAliasTagButton.isSelected && !self.addAccountTagButton.isSelected) {
        [MsgToolBox showAlert:@"" content:@"请选择标签类型"];
        return;
    }

    int bindTag = 1;
    if (self.addAliasTagButton.isSelected) {
        bindTag = 3;
        if ([[self.addAliasTagButton getValue] isEqualToString:@"未选择别名"]) {
            [MsgToolBox showAlert:@"" content:@"请选择别名"];
            return;
        }
    }

    if (self.addAccountTagButton.isSelected) {
        bindTag = 2;
    }

    [CloudPushSDK bindTag:bindTag withTags:@[self.tagNameTextField.text] withAlias:self.alias withCallback:^(CloudPushCallbackResult *res) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (res.success) {
                 [CustomToastUtil showToastWithMessage:@"标签添加成功！" isSuccess:YES];

                 if (self.addHandle) {
                     SettingTag *tag = [[SettingTag alloc] init];
                     tag.tagName = self.tagNameTextField.text;
                     tag.tagType = bindTag;
                     tag.tagAlias = self.alias;
                     self.addHandle(tag);
                 }
                 [self goBack:nil];
             } else {
                 [CustomToastUtil showToastWithMessage:@"标签添加失败！" isSuccess:NO];
             }
         });
     }];
}

@end
