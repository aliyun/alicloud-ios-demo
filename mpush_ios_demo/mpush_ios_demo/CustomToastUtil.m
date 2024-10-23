//
//  CustomToastUtil.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/21.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "CustomToastUtil.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation CustomToastUtil

+ (void)showToastWithMessage:(NSString *)message {
    // 设置 Toast 标签
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.font = [UIFont systemFontOfSize:14 weight:500];
    messageLabel.textColor = [UIColor colorWithHexString:@"#475866"];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.numberOfLines = 0;
    
    // 设置成功图标
    UIImageView *successIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toast_success"]];
    
    // 调整标签大小以适应消息文本
    CGSize maxSize = CGSizeMake(kScreenWidth * 0.8, kScreenHeight * 0.8);
    CGSize expectedSize = [message boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : messageLabel.font } context:nil].size;
    messageLabel.frame = CGRectMake(30, 0, expectedSize.width + 10, expectedSize.height + 20);
    successIcon.frame = CGRectMake(10, (expectedSize.height + 20 - 14)/2, 14, 14);
    
    // 设置 Toast 背景
    UIView *toastView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30 + messageLabel.bounds.size.width, messageLabel.bounds.size.height)];
    toastView.backgroundColor = UIColor.whiteColor;
    toastView.layer.borderWidth = 1;
    toastView.layer.borderColor = [UIColor colorWithRed:65/255.0 green:73/255.0 blue:86/255.0 alpha:0.1].CGColor;
    toastView.layer.cornerRadius = 10;
    toastView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    toastView.clipsToBounds = YES;
    
    [toastView addSubview:successIcon];
    [toastView addSubview:messageLabel];
    
    // 添加背景view
    [[UIApplication sharedApplication].keyWindow addSubview:toastView];
    
    // 动画
    toastView.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        toastView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:2 options:0 animations:^{
            toastView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [toastView removeFromSuperview];
        }];
    }];
}

@end
