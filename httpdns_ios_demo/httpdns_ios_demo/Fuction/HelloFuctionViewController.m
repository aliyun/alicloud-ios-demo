//
//  HelloFuctionViewController.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/11.
//

#import "HelloFuctionViewController.h"
#import "ResolveTypeButton.h"
#import "ChooseOrInputDomainViewController.h"

@interface HelloFuctionViewController ()<ChooseOrInputDomainDelegate>

@property (weak, nonatomic) IBOutlet UITextField *domainsTextField;
@property (weak, nonatomic) IBOutlet ResolveTypeButton *syncResolveButton;
@property (weak, nonatomic) IBOutlet ResolveTypeButton *asyncResolveButton;
@property (weak, nonatomic) IBOutlet ResolveTypeButton *syncResolveNonBlockingButton;
@property (weak, nonatomic) IBOutlet UIButton *resolveButton;

@end

@implementation HelloFuctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)updateResolveButtonState {
    if ([HTTPDNSTools isValidString:self.domainsTextField.text]) {
        [self.resolveButton setEnabled:YES];
    }
}

#pragma mark - action

- (IBAction)syncButton:(id)sender {
    [self.syncResolveButton setSelected:YES];
    [self.asyncResolveButton setSelected:NO];
    [self.syncResolveNonBlockingButton setSelected:NO];
}

- (IBAction)asyncButton:(id)sender {
    [self.asyncResolveButton setSelected:YES];
    [self.syncResolveButton setSelected:NO];
    [self.syncResolveNonBlockingButton setSelected:NO];
}

- (IBAction)syncNonBlockingButton:(id)sender {
    [self.syncResolveNonBlockingButton setSelected:YES];
    [self.asyncResolveButton setSelected:NO];
    [self.syncResolveButton setSelected:NO];
}

- (IBAction)chooseOrInputHost:(id)sender {
    ChooseOrInputDomainViewController *domainViewController = [HTTPDNSTools storyBoardInstantiateViewController:@"ChooseOrInputDomainViewController"];
    domainViewController.delegate = self;
    [self.navigationController showViewController:domainViewController sender:nil];
}

#pragma mark - ChooseOrInputDomainDelegate

- (void)domainResult:(NSString *)domain {
    self.domainsTextField.text = domain;
    [self updateResolveButtonState];
}

@end
