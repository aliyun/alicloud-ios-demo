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
static NSString * const kAppKey = @"";
static NSString * const kAppSecret = @"";

@interface YWLoginController()<UIActionSheetDelegate>
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
    self.buttonLogin.layer.cornerRadius = 5.0f;
    self.appkeyLabel.text = [NSString stringWithFormat:@"Appkey: %@", kAppKey];
}

#pragma mark - methods
/** 打开用户反馈页面 */
- (void)openFeedbackViewController {
    //  初始化方式,或者参考下方的`- (YWFeedbackKit *)feedbackKit`方法。
    //  self.feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey];
    
    /** 设置App自定义扩展反馈数据 */
    self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                 @"visitPath":@"登陆->关于->反馈",
                                 @"userid":@"yourid",
                                 @"应用自定义扩展信息":@"开发者可以根据需要设置不同的自定义信息，方便在反馈系统中查看"};
    
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
    
    /** 使用自定义的方式抛出error */
//    [self.feedbackKit setYWFeedbackViewControllerErrorBlock:^(YWFeedbackViewController *viewController, NSError *error) {
//        NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
//        [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
//                                                       description:[NSString stringWithFormat:@"%ld", error.code]
//                                                              type:TWMessageBarMessageTypeError];
//    }];
}

/** 查询未读数 */
- (void)fetchUnreadCount {
    __weak typeof(self) weakSelf = self;
    [self.feedbackKit getUnreadCountWithCompletionBlock:^(NSInteger unreadCount, NSError *error) {
        if (error == nil) {
            NSString *desc = [NSString stringWithFormat:@"未读数：%ld", (long)unreadCount];
            weakSelf.buttonUnread.shouldHideBadgeAtZero = NO;
            weakSelf.buttonUnread.badgeValue = [NSString stringWithFormat:@"%ld", (long)unreadCount];
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"成功获取未读数！"
                                                           description:desc
                                                                  type:TWMessageBarMessageTypeSuccess];
        } else {
            NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                           description:nil
                                                                  type:TWMessageBarMessageTypeError];
        }
    }];
}

#pragma mark getter
- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
    }
    return _feedbackKit;
}

#pragma mark actions
- (IBAction)actionStart:(id)sender {
    [self openFeedbackViewController];
}
/** 扫码预览 */
- (IBAction)actionScanCode:(id)sender {
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
    [self fetchUnreadCount];
}
- (IBAction)actionBackground:(id)sender {
    [self.view endEditing:YES];
}
#pragma mark UISplitViewController delegate
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation  NS_DEPRECATED_IOS(5_0, 8_0, "Use preferredDisplayMode instead") {
    return NO;
}

@end
