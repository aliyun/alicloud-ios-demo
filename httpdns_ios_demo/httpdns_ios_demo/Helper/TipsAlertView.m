//
//  TipsAlertView.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/18.
//

#import "TipsAlertView.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TipsAlertView()

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *contentLabel;
@property(nonatomic, strong)UIView *shadeView;
@end

@implementation TipsAlertView

+ (void)alertShow:(NSString *)title message:(NSString *)message domain:(NSString *)domain {
    TipsAlertView *alertView = [[TipsAlertView alloc]initWithTitle:title message:message domain:domain];
    [alertView show];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message domain:(NSString *)domain {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        [self setupViews];

        self.titleLabel.text = title;

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentJustified;
        paragraphStyle.lineSpacing = 10;

        NSDictionary *attributes = @{
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: [UIFont systemFontOfSize:13],
            NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#384153"]
        };

        NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc]initWithString:message attributes:attributes];

        NSRange domainRange = [message rangeOfString:domain];
        if (domainRange.location != NSNotFound) {
            [attributedMessage addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor colorWithHexString:@"#3E3D46"]
                                      range:domainRange];
        }

        self.contentLabel.attributedText = attributedMessage;
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.shadeView];

    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth * 296/375, kScreenWidth * 296/375 )];
    backView.layer.cornerRadius = 8;
    backView.center = self.center;
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];

    [backView addSubview:self.titleLabel];
    [backView addSubview:self.contentLabel];

    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#E6E8EB"];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [backView addSubview:line];

    UIButton *confirmButton = [[UIButton alloc]init];
    [confirmButton setTitle:@"知道了" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#1B58F4"] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:500];
    confirmButton.backgroundColor = [UIColor clearColor];
    [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
    [backView addSubview:confirmButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:backView.topAnchor constant:24],
        [self.titleLabel.centerXAnchor constraintEqualToAnchor:backView.centerXAnchor],
        [self.titleLabel.heightAnchor constraintEqualToConstant:20],

        [confirmButton.leftAnchor constraintEqualToAnchor:backView.leftAnchor],
        [confirmButton.rightAnchor constraintEqualToAnchor:backView.rightAnchor],
        [confirmButton.bottomAnchor constraintEqualToAnchor:backView.bottomAnchor],
        [confirmButton.heightAnchor constraintEqualToConstant:44],

        [line.leftAnchor constraintEqualToAnchor:backView.leftAnchor],
        [line.rightAnchor constraintEqualToAnchor:backView.rightAnchor],
        [line.topAnchor constraintEqualToAnchor:confirmButton.topAnchor],
        [line.heightAnchor constraintEqualToConstant:1],

        [self.contentLabel.leftAnchor constraintEqualToAnchor:backView.leftAnchor constant:24],
        [self.contentLabel.rightAnchor constraintEqualToAnchor:backView.rightAnchor constant:-24],
        [self.contentLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:8],
        [self.contentLabel.bottomAnchor constraintEqualToAnchor:line.topAnchor]
    ]];
}

- (void)confirmClick {
    [self close];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)close {
    [self removeFromSuperview];
}

#pragma mark - lazy load

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:500];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#1F2024"];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.numberOfLines = 0;
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentLabel;
}

- (UIView *)shadeView {
    if (!_shadeView) {
        _shadeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _shadeView.backgroundColor = [UIColor colorWithHexString:@"#404345"];
        _shadeView.alpha = 0.4;
    }
    return _shadeView;
}

@end
