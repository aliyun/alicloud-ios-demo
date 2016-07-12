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

- (void)viewWillAppear:(BOOL)animated {
    // 进入页面
    [[ALBBMANPageHitHelper getInstance] pageAppear:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 离开页面
    [[ALBBMANPageHitHelper getInstance] pageDisAppear:self];
}

@end