//
//  UIAlertController+aliccdemo.h
//  AlicloudCloudCodeTestsDemo
//
//  Created by yannan on 2021/2/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (CloudCodeDemo)

+ (void)alicc_showAlertTitle:(NSString *)title message:(NSString *)message parentVC:(UIViewController *)parentVC;

@end

NS_ASSUME_NONNULL_END
