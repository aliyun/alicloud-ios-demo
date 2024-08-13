//
//  HTTPDNSDemoLoading.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/8/13.
//

#import "HTTPDNSDemoLoading.h"

@interface HTTPDNSDemoLoading()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation HTTPDNSDemoLoading

+ (void)showLoading {
    HTTPDNSDemoLoading *loading = [[HTTPDNSDemoLoading alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [loading show];
}

+ (void)stopLoading {
    for (HTTPDNSDemoLoading *loading in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([loading isMemberOfClass:[HTTPDNSDemoLoading class]]) {
            [loading close];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

        // 创建活动指示器
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.center = self.center;
        [self addSubview:self.activityIndicator];
    }
    return self;
}

- (void)startLoading {
    self.activityIndicator.center = self.center;
    [self.activityIndicator startAnimating];
    self.hidden = NO;
}

- (void)stopLoading {
    [self.activityIndicator stopAnimating];
    self.hidden = YES;
}

- (void)show {
    [self startLoading];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)close {
    [self stopLoading];
    [self removeFromSuperview];
}

@end
