//
//  ImageAlertView.m
//  httpdns_ios_demo
//
//  Created by wy on 2024/9/9.
//

#import "ImageAlertView.h"

@interface ImageAlertView()

@property(nonatomic, strong) UIView *shadeView;
@property(nonatomic, copy) ImageViewHandler imageViewHandler;

@end

@implementation ImageAlertView

+ (void)imageAlertShow:(ImageViewHandler)handler {
    ImageAlertView *alertView = [[ImageAlertView alloc] initWithImageHandler:handler];
    [alertView show];
}

- (instancetype)initWithImageHandler:(ImageViewHandler)handler {
    self = [super initWithFrame:UIScreen.mainScreen.bounds];
    if (self) {
        self.imageViewHandler = handler;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.shadeView];
    
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kScreenHeight = [UIScreen mainScreen].bounds.size.height;

    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, (kScreenHeight - kScreenWidth)/2, kScreenWidth - 20, kScreenWidth - 20)];
    backgroundView.layer.cornerRadius = 8;
    backgroundView.layer.masksToBounds = YES;
    backgroundView.backgroundColor = UIColor.whiteColor;
    [self addSubview:backgroundView];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:backgroundView.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backgroundView addSubview:imageView];
    
    if (self.imageViewHandler) {
        self.imageViewHandler(imageView);
    }
    
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 20, backgroundView.frame.origin.y + backgroundView.frame.size.height + 20, 40, 40)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"Close_Alert"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
}

- (void)close {
    [self removeFromSuperview];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}


#pragma mark - lazy load

- (UIView *)shadeView {
    if (!_shadeView) {
        _shadeView = [[UIView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        _shadeView.backgroundColor = [UIColor colorWithHexString:@"#404345"];
        _shadeView.alpha = 0.4;
    }
    return _shadeView;
}

@end
