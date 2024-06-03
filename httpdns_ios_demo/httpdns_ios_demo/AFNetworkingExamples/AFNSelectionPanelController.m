//
//  AFNChooseTypeViewController.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/5/27.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "AFNSelectionPanelController.h"
#import "AFNHttpsScenario.h"
#import "AFNHttpsWithSNIScenario.h"

@interface AFNSelectionPanelController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AFNSelectionPanelController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)httpsScenario:(id)sender {
    [self cleanTextView];

    NSString *originalUrl = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt";
    [AFNHttpsScenario httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = message;
        });
    }];
}

- (IBAction)httpsWithSNIScenario:(id)sender {
    [self cleanTextView];

    NSString *originalUrl = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt";
    [AFNHttpsWithSNIScenario httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
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
