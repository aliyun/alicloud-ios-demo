//
//  ViewController.m
//  man_ios_demo
//
//  Created by nanpo.yhl on 15/10/10.
//  Copyright (c) 2015年 com.aliyun.mobile. All rights reserved.
//

#import "ViewController.h"
#import "ManIOSDemo.h"
#import "TestUIViewController.h"
#import "MANClientRequest.h"
#import "MANH5DemoViewController.h"

#import <AlicloudMobileAnalitics/ALBBMAN.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ManIOSDemo getInstance] oneTest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *	@brief	UIViewController跳转，页面事件埋点
 *
 *	@param 	sender
 */
- (IBAction)onJmpButton:(id)sender {
    TestUIViewController *jmpViewController = [[TestUIViewController alloc] init];
//    jmpViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:jmpViewController animated:YES completion:^{
        
    }];
}

- (IBAction)onH5Clicked:(id)sender {
    MANH5DemoViewController *h5 = [[MANH5DemoViewController alloc] init];
    [self presentViewController:h5 animated:YES completion:nil];
}

@end
