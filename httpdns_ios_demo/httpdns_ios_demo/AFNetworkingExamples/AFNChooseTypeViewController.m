//
//  AFNChooseTypeViewController.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/5/27.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "AFNChooseTypeViewController.h"
#import "AFNHttpsScene.h"
#import "AFNHttpsWithSNIScene.h"

@interface AFNChooseTypeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AFNChooseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)beginHttpsScene:(id)sender {
    [self cleanTextView];

    __block NSString *responseIp;
    NSString *originalUrl = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt";

    [[AFNHttpsScene new] beginQuery:originalUrl completionHandler:^(NSString *ip, NSString *text) {
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
            [[AFNHttpsScene new] beginQuery:originalUrl completionHandler:^(NSString * _Nonnull ip, NSString * _Nonnull text) {
                self.textView.text = text;
            }];
        }
    });
}

- (IBAction)beginHttpsWithSNIScene:(id)sender {
    [self cleanTextView];

    __block NSString *responseIp;
    NSString *originalUrl = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt";

    [AFNHttpsWithSNIScene beginQuery:originalUrl completionHandler:^(NSString * _Nonnull ip, NSString * _Nonnull text) {
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
            [AFNHttpsWithSNIScene beginQuery:originalUrl completionHandler:^(NSString * _Nonnull ip, NSString * _Nonnull text) {
                self.textView.text = text;
            }];
        }

    });
}

- (void)cleanTextView {
    [self.textView setContentOffset:CGPointZero animated:YES];
    self.textView.text = nil;
}

@end
