//
//  YWLoginController.m
//  YWFeedbackDemo
//
//  Created by 慕桥（黄玉坤） on 16/1/21.
//  Copyright (c) 2016年 alibaba. All rights reserved.
//

#import "YWLoginController.h"
#import "TWMessageBarManager.h"
#import "AVQRViewController.h"
#import <BCHybridWebViewFMWK/BCHybridWebView.h>
#import "UIButton+Badge.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>

#warning 修改为你自己的 appkey 和 appSecret。
static NSString * const kAppKey = @"333740861";
static NSString * const kAppSecret = @"b4eecb377a2b42a19dd60bbe5abb2766";

@interface YWLoginController()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UIButton *buttonUnread;
@property (weak, nonatomic) IBOutlet UIButton *buttonScanCode;
@property (weak, nonatomic) IBOutlet UIButton *buttonUnreadTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonScanCodeTitle;
@property (weak, nonatomic) IBOutlet UILabel  *appkeyLabel;

@end

/// for iPad
@interface YWLoginController ()<UISplitViewControllerDelegate>
@property (nonatomic, strong) YWFeedbackKit *feedbackKit;
@end

@implementation YWLoginController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = [NSString stringWithFormat:@"Appkey: %@", kAppKey];
}

#pragma mark - methods
/** 打开用户反馈页面 */
- (void)openFeedbackViewController {
    /** 设置App自定义扩展反馈数据 */
//    self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
//                                 @"visitPath":@"登陆->关于->反馈",
//                                 @"userid":@"yourid",
//                                 @"应用自定义扩展信息":@"开发者可以根据需要设置不同的自定义信息，方便在反馈系统中查看"};
    // demo这里根据设置页的设置，如果有开启自定义拓展反馈数据，就传
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *setting = [defaults objectForKey:@"YWSettingInfo"];
    if (setting) {
        // 根据设置 配置自定义拓展信息
        if (setting[@"customSwitch"] && [setting[@"customSwitch"] boolValue]) {
            self.feedbackKit.extInfo = @{
                @"应用自定义扩展信息":@"开发者可以根据需要设置不同的自定义信息，方便在反馈系统中查看",
                @"userId":@"111"
            };
        } else {
            self.feedbackKit.extInfo = nil;
        }
        
        // 根据设置 配置用户昵称
        if (setting[@"userName"]) {
            [self.feedbackKit setUserNick:[NSString stringWithFormat:@"%@",setting[@"userName"]]];
        } else {
            [self.feedbackKit setUserNick:nil];
        }
        
        // 根据设置 配置导航栏按键字体大小
        if (setting[@"font"] && [setting[@"font"] length] != 0) {
            self.feedbackKit.defaultCloseButtonTitleFont = [UIFont systemFontOfSize:[setting[@"font"] floatValue]];
            self.feedbackKit.defaultRightBarButtonItemTitleFont = [UIFont systemFontOfSize:[setting[@"font"] floatValue]];
        } else {
            self.feedbackKit.defaultCloseButtonTitleFont = nil;
            self.feedbackKit.defaultRightBarButtonItemTitleFont = nil;
        }
        
        // 根据设置 配置自定义错误提示
        if (setting[@"errorSwitch"] && [setting[@"errorSwitch"] boolValue]) {
            /** 使用自定义的方式抛出error */
            [self.feedbackKit setYWFeedbackViewControllerErrorBlock:^(YWFeedbackViewController *viewController, NSError *error) {
                NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                               description:[NSString stringWithFormat:@"%ld", error.code]
                                                                      type:TWMessageBarMessageTypeError];
            }];
        } else {
            self.feedbackKit.YWFeedbackViewControllerErrorBlock = nil;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if (viewController != nil) {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            [weakSelf presentViewController:nav animated:YES completion:nil];
            
            [viewController setCloseBlock:^(UIViewController *aParentController){
                [aParentController dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            /** 使用自定义的方式抛出error时，此部分可以注释掉 */
            NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                           description:nil
                                                                  type:TWMessageBarMessageTypeError];
        }
    }];
}

/** 查询未读数 */
- (void)fetchUnreadCount {
    __weak typeof(self) weakSelf = self;
    [self.feedbackKit getUnreadCountWithCompletionBlock:^(NSInteger unreadCount, NSError *error) {
        NSString *title;
        if (error == nil) {
            NSString *desc = [NSString stringWithFormat:@"未读数：%ld", (long)unreadCount];
            weakSelf.buttonUnread.shouldHideBadgeAtZero = NO;
            weakSelf.buttonUnread.badgeValue = [NSString stringWithFormat:@"%ld", (long)unreadCount];
            title = [NSString stringWithFormat: @"成功获取未读数！\n %@", desc];
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"成功获取未读数！"
                                                           description:desc
                                                                  type:TWMessageBarMessageTypeSuccess];
        } else {
            title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                           description:nil
                                                                  type:TWMessageBarMessageTypeError];
        }
        self.textView.text = title;
    }];
}

#pragma mark getter
- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        // SDK初始化，手动配置appKey/appSecret
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
    }
    return _feedbackKit;
}

#pragma mark actions
- (IBAction)actionStart:(id)sender {
    [self cleanTextView];
    [self openFeedbackViewController];
}

/** 扫码预览 */
- (IBAction)actionScanCode:(id)sender {
    [self cleanTextView];
    AVQRViewController *vc = [[AVQRViewController alloc] init];
    __weak typeof(vc) weakVC = vc;
    __weak typeof(self) weakSelf = self;
    vc.readFinishedBlock = ^(NSString *text){
        [weakVC dismissViewControllerAnimated:YES completion:^{
            NSDictionary *configration = @{
                                         @"photoFromCancel" : @"拍摄照片",
                                         @"photoFromCamera" : @"相册选取",
                                         @"photoFromAlbum" : @"取消",
                                         };
            
            YWFeedbackViewController *webVC = [[YWFeedbackViewController alloc] initWithFeedbackKit:self.feedbackKit extInfo:nil configration:configration];
            webVC.closeBlock = ^(YWFeedbackViewController *feedbackController){
                [feedbackController dismissViewControllerAnimated:YES completion:nil];
            };
            [webVC view];
            [webVC.contentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:text?:@""]]];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
            [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
        }];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
}
- (IBAction)actionUnreadCount:(id)sender {
    [self cleanTextView];
    [self fetchUnreadCount];
}

- (void)cleanTextView {
//    self.textView.text = nil;
    self.textView.text = [NSString stringWithFormat:@"Appkey: %@", kAppKey];
}

- (IBAction)actionBackground:(id)sender {
    [self.view endEditing:YES];
}
#pragma mark UISplitViewController delegate
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation  NS_DEPRECATED_IOS(5_0, 8_0, "Use preferredDisplayMode instead") {
    return NO;
}

@end
