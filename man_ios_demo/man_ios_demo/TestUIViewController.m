//
//  TestUIViewController.m
//  man_ios_demo
//  
//  Created by lingkun on 16/2/1.
//  Copyright © 2016年 com.aliyun.mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlicloudMobileAnalitics/ALBBMAN.h>
#import "TestUiViewController.h"

@implementation TestUIViewController

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    view.backgroundColor = [UIColor greenColor];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 30, 300, 30);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 设置页面事件扩展参数
    NSDictionary *properties = [NSDictionary dictionaryWithObject:@"pageValue" forKey:@"pageKey"];
    [[ALBBMANPageHitHelper getInstance] updatePageProperties:self properties:properties];
}

// 返回
- (void)back {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end