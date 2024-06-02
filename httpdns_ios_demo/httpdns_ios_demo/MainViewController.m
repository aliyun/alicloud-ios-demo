//
//  MainViewController.m
//  httpdns_ios_demo
//
//  入口ViewController
//  Created by DaveLam on 16/7/3.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "MainViewController.h"
#import "GeneralScene.h"
#import "HTTPSScene.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import <AlicloudUtils/AlicloudUtils.h>
#import "HTTPSWithSNIScene.h"
#import "AFNChooseTypeViewController.h"


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

- (IBAction)beginGeneralScenceQuery:(id)sender {
    [self cleanTextView:nil];

    NSString *originalUrl = @"http://www.aliyun.com";
    [GeneralScene httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = message;
        });
    }];
}

- (IBAction)beginHTTPSSceneQuery:(id)sender {
    [self cleanTextView:nil];

    NSString *originalUrl = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt";
    [[HTTPSScene new] httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = message;
        });
    }];
}

- (IBAction)beginHTTPSWithSNISceneQuery:(id)sender {
    [self cleanTextView:nil];

    NSString *originalUrl = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt";
    [HTTPSWithSNIScene httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
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
