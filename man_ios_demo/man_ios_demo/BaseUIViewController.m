//
//  BaseUIViewController.m
//  man_ios_demo
//  UIViewController基类
//  Created by lingkun on 16/2/1.
//  Copyright © 2016年 com.aliyun.mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlicloudMobileAnalitics/ALBBMAN.h>
#import "BaseUIViewController.h"

@implementation BaseUIViewController

- (void)viewDidAppear:(BOOL)animated {
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    // 进入页面
    [tracker pageAppear:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    // 离开页面
    [tracker pageDisAppear:self];
}

@end