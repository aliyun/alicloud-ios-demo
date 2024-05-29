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

- (IBAction)beginCommonScenceQuery:(id)sender {
    [self cleanTextView:nil];

    __block NSString *responseIp;
    NSString *originalUrl = @"http://www.aliyun.com";
    [GeneralScene beginQuery:originalUrl completionHandler:^(NSString *ip, NSString *text) {
        responseIp = ip;
        if (ip) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = text;
            });
        }
    }];

    NSUInteger delaySeconds = 1;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        if (responseIp == nil) {
            [GeneralScene beginQuery:originalUrl completionHandler:^(NSString * _Nonnull ip, NSString * _Nonnull text) {
                self.textView.text = text;
            }];
        }
    });
}

- (IBAction)beginHTTPSSceneQuery:(id)sender {
    [self cleanTextView:nil];

    __block NSString *responseIp;
    NSString *originalUrl = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt";

    [[HTTPSScene new] beginQuery:originalUrl completionHandler:^(NSString *ip, NSString *text) {
        responseIp = ip;
        if (ip) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = text;
            });
        }
    }];

    NSUInteger delaySeconds = 1;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        if (responseIp == nil) {
            [[HTTPSScene new] beginQuery:originalUrl completionHandler:^(NSString * _Nonnull ip, NSString * _Nonnull text) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.textView.text = text;
                });
            }];
        }

    });
}

- (IBAction)beginHTTPSWithSNISceneQuery:(id)sender {
    [self cleanTextView:nil];

    __block NSString *responseIp;
    NSString *originalUrl = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt";

    [HTTPSWithSNIScene beginQuery:originalUrl completionHandler:^(NSString * _Nonnull ip, NSString * _Nonnull text) {
        responseIp = ip;
        if (ip) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = text;
            });
        }
    }];

    NSUInteger delaySeconds = 1;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        if (responseIp == nil) {
            [HTTPSWithSNIScene beginQuery:originalUrl completionHandler:^(NSString * _Nonnull ip, NSString * _Nonnull text) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.textView.text = text;
                });
            }];
        }
    });
}


- (IBAction)cleanTextView:(id)sender {
    [self.textView setContentOffset:CGPointZero animated:YES];
    self.textView.text = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
