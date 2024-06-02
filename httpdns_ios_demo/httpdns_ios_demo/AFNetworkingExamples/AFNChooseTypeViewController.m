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

- (IBAction)httpsScene:(id)sender {
    [self cleanTextView];

    NSString *originalUrl = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt";
    [AFNHttpsScene httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = message;
        });
    }];
}

- (IBAction)httpsWithSNIScene:(id)sender {
    [self cleanTextView];

    NSString *originalUrl = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt";
    [AFNHttpsWithSNIScene httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = message;
        });
    }];
}

- (void)cleanTextView {
    [self.textView setContentOffset:CGPointZero animated:YES];
    self.textView.text = nil;
}

@end
