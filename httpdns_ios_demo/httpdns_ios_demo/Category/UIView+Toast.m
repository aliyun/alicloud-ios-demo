//
//  UIView+Toast.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/8/1.
//

#import "UIView+Toast.h"

@implementation UIView (Toast)

- (void)showToastWithMessage:(NSString *)message duration:(NSTimeInterval)duration {
    // 设置 Toast 标签
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.font = [UIFont boldSystemFontOfSize:16];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;

    // 调整标签大小以适应消息文本
    CGSize maxSize = CGSizeMake(self.bounds.size.width * 0.8, self.bounds.size.height * 0.8);
    CGSize expectedSize = [message boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : messageLabel.font } context:nil].size;
    messageLabel.frame = CGRectMake(0, 0, expectedSize.width + 40, expectedSize.height + 20);

    // 设置 Toast 背景
    UIView *toastView = [[UIView alloc] initWithFrame:messageLabel.bounds];
    toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    toastView.layer.cornerRadius = 10;
    toastView.center = self.center;
    toastView.clipsToBounds = YES;

    [toastView addSubview:messageLabel];
    messageLabel.center = CGPointMake(CGRectGetWidth(toastView.frame) / 2, CGRectGetHeight(toastView.frame) / 2);

    // 添加到主视图
    [self addSubview:toastView];

    // 动画
    toastView.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        toastView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:duration options:0 animations:^{
            toastView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [toastView removeFromSuperview];
        }];
    }];
}

@end
