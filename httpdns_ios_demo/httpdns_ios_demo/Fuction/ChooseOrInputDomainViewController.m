//
//  ChooseOrInputHostViewController.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/12.
//

#import "ChooseOrInputDomainViewController.h"

@interface ChooseOrInputDomainViewController ()

@end

@implementation ChooseOrInputDomainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseFinish:(id)sender {
    if ([self.delegate respondsToSelector:@selector(domainResult:)]) {
        [self.delegate domainResult:@"www.aliyun.com"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
