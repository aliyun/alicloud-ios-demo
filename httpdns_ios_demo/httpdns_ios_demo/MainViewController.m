//
//  MainViewController.m
//  httpdns_ios_demo
//
//  入口ViewController
//  Created by DaveLam on 16/7/3.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "MainViewController.h"
#import "GeneralScenario.h"
#import "HTTPSSimpleScenario.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import <AlicloudUtils/AlicloudUtils.h>
#import "HTTPSWithSNIScenario.h"
#import "AFNSelectionPanelController.h"


@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 获取用户sessionId
    NSString *sessionId = [[HttpDnsService sharedInstance] getSessionId];
    NSLog(@"Get sessionId: %@", sessionId);

    // 获取当前网络协议栈
    [self getCurrentIPStackTypeSample];
}

- (void)getCurrentIPStackTypeSample {
    AlicloudIPv6Adapter *adapter = [AlicloudIPv6Adapter getInstance];
    AlicloudIPStackType stackType = [adapter currentIpStackType];
    switch (stackType) {
        case kAlicloudIPv4only:
            NSLog(@"当前网络栈为IPv4");
            break;
        case kAlicloudIPv6only:
            NSLog(@"当前网络栈为IPv6");
            break;
        case kAlicloudIPdual:
            NSLog(@"当前网络栈为IPv4/IPv6双栈");
            break;
        default:
            NSLog(@"无法获取当前网络栈类型");
            break;
    }
}

- (IBAction)generalScenario:(id)sender {
    [self cleanTextView:nil];

    NSString *originalUrl = @"http://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt";
    [GeneralScenario httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = message;
        });
    }];
}

- (IBAction)httpsScenario:(id)sender {
    [self cleanTextView:nil];

    NSString *originalUrl = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt";
    [[HTTPSSimpleScenario new] httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = message;
        });
    }];
}

- (IBAction)httpsWithSNIScenario:(id)sender {
    [self cleanTextView:nil];

    NSString *originalUrl = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt";
    [HTTPSWithSNIScenario httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = message;
        });
    }];
}


- (IBAction)cleanTextView:(id)sender {
    [self.textView setContentOffset:CGPointZero animated:NO];
    self.textView.text = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
