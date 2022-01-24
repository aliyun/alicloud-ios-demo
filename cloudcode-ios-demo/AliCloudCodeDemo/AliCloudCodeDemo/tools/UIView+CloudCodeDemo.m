//
//  UIView+CloudCodeDemo.m
//  AliCloudCodeDemo
//
//  Created by yannan on 2022/1/21.
//

#import "UIView+CloudCodeDemo.h"

@implementation UIView (CloudCodeDemo)

- (CGFloat)cloudCode_left {
    return self.frame.origin.x;
}


- (void)setCloudCode_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)cloudCode_top {
    return self.frame.origin.y;
}


- (void)setCloudCode_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)cloudCode_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setCloudCode_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)cloudCode_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setCloudCode_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)cloudCode_width {
    return self.frame.size.width;
}

- (void)setCloudCode_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)cloudCode_height {
    return self.frame.size.height;
}

- (void)setCloudCode_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)cloudCode_centerX {
    return self.center.x;
}

- (void)setCloudCode_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)cloudCode_centerY {
    return self.center.y;
}

- (void)setCloudCode_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)cloudCode_origin {
    return self.frame.origin;
}

- (void)setCloudCode_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)cloudCode_size {
    return self.frame.size;
}

- (void)setCloudCode_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}




- (void)cloudCode_removeAllSubViews {
    NSArray *ary = [self.subviews copy];
    for (UIView *view in ary) {
        [view removeFromSuperview];
    }
}


@end
