//
//  MsgToolBox.m
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/3/31.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "MsgToolBox.h"

@implementation MsgToolBox

+ (void)showAlert:(NSString *)title content:(NSString *)content {
    // 保证在主线程上执行
    if ([NSThread isMainThread]) {
        [self show:title content:content];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self show:title content:content];
        });
    }
}

+ (void)show:(NSString *)title content:(NSString *)content {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"已阅" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancleAction];
    [[self getCurrentViewController] presentViewController:alert animated:YES completion:nil];
}

+ (UIViewController *)getCurrentViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:((UINavigationController *)vc).visibleViewController];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:((UITabBarController *)vc).selectedViewController];
    } else if (vc.presentedViewController) {
        return [self getVisibleViewControllerFrom:vc.presentedViewController];
    } else {
        return vc;
    }
}

@end
