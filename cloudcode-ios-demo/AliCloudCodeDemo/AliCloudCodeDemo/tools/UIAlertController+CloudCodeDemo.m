//
//  UIAlertController+aliccdemo.m
//  AlicloudCloudCodeTestsDemo
//
//  Created by yannan on 2021/2/7.
//

#import "UIAlertController+CloudCodeDemo.h"

@implementation UIAlertController (CloudCodeDemo)

+ (void)alicc_showAlertTitle:(NSString *)title message:(NSString *)message parentVC:(UIViewController *)parentVC {
    __weak __typeof(parentVC) weakSelfParentVC= parentVC;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(alertVC) weakSelf = alertVC;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertVC addAction:action];
    [weakSelfParentVC presentViewController:alertVC animated:YES completion:nil];
    
    
    
    
}

@end
