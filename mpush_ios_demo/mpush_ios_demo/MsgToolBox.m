//
//  MsgToolBox.m
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/3/31.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "MsgToolBox.h"

@implementation MsgToolBox

+ (void) showAlert:(NSString *)title content:(NSString *)content {
    // 保证在主线程上执行
    if ([NSThread isMainThread]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
            [alertView show];
        });
    }
}

@end
