//
//  HelloFuctionViewController.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/11.
//

#import "HelloFuctionViewController.h"
#import "ResolveTypeButton.h"
#import "ChooseOrInputDomainViewController.h"
#import "ResolveFuctionViewController.h"
#import "TipsAlertView.h"

@interface HelloFuctionViewController ()<ChooseOrInputDomainDelegate>

@property (weak, nonatomic) IBOutlet UITextField *domainTextField;
@property (weak, nonatomic) IBOutlet ResolveTypeButton *syncResolveButton;
@property (weak, nonatomic) IBOutlet ResolveTypeButton *asyncResolveButton;
@property (weak, nonatomic) IBOutlet ResolveTypeButton *syncNonBlockingResolveButton;
@property (weak, nonatomic) IBOutlet UILabel *resolveTypeExplanation;
@property (weak, nonatomic) IBOutlet UIButton *resolveButton;

@property(nonatomic, assign)ResolveType resolveType;

@end

@implementation HelloFuctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)updateResolveButtonState {
    if ([HTTPDNSDemoTools isValidString:self.domainTextField.text]) {
        [self.resolveButton setEnabled:YES];
    }
}

#pragma mark - action

- (IBAction)syncButton:(id)sender {
    [self.syncResolveButton setSelected:YES];
    [self.asyncResolveButton setSelected:NO];
    [self.syncNonBlockingResolveButton setSelected:NO];

    self.resolveTypeExplanation.text = @"使用同步解析接口解析域名，会阻塞当前线程，直到获得有效解析结果并返回。";
    self.resolveType = ResolveTypeSync;
}

- (IBAction)asyncButton:(id)sender {
    [self.asyncResolveButton setSelected:YES];
    [self.syncResolveButton setSelected:NO];
    [self.syncNonBlockingResolveButton setSelected:NO];

    self.resolveTypeExplanation.text = @"使用异步解析接口解析域名，不会阻塞当前线程，解析结果会通过回调的形式返回。";
    self.resolveType = ResolveTypeAsync;
}

- (IBAction)syncNonBlockingButton:(id)sender {
    [self.syncNonBlockingResolveButton setSelected:YES];
    [self.asyncResolveButton setSelected:NO];
    [self.syncResolveButton setSelected:NO];

    self.resolveTypeExplanation.text = @"使用同步非阻塞接口解析域名，不会阻塞当前线程，但可能会返回空结果。";
    self.resolveType = ResolveTypeSyncNoBlocking;
}

- (IBAction)beginResolve:(id)sender {
    ResolveFuctionViewController *resolveViewController = [HTTPDNSDemoTools storyBoardInstantiateViewController:@"ResolveFuctionViewController"];
    [self.navigationController showViewController:resolveViewController sender:nil];
    
    // 延迟0.1s 等UI控件加载完成后再进行调用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [resolveViewController resolveHost:self.domainTextField.text type:self.resolveType];
    });
}

- (IBAction)chooseOrInputHost:(id)sender {
    ChooseOrInputDomainViewController *domainViewController = [HTTPDNSDemoTools storyBoardInstantiateViewController:@"ChooseOrInputDomainViewController"];
    domainViewController.delegate = self;
    [self.navigationController showViewController:domainViewController sender:nil];
}

#pragma mark - ChooseOrInputDomainDelegate

- (void)domainResult:(NSString *)domain isInput:(BOOL)isInput {
    if (isInput) {
        [TipsAlertView alertShow:@"域名解析提醒" message:[NSString stringWithFormat:@"在解析开始前，请将下方域名添加到阿里云控制台HTTPDNS的“域名列表”；否则无法返回解析结果。\n\n%@\n\n若已添加，则忽略此消息",domain] domain:domain];
    }

    self.domainTextField.text = domain;
    [self updateResolveButtonState];
}

@end
