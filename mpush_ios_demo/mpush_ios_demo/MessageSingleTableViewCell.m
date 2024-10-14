//
//  MessageSingleTableViewCell.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/14.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "MessageSingleTableViewCell.h"

@interface MessageSingleTableViewCell()

@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation MessageSingleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.iconImageView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16],
        [self.iconImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:16],
        [self.iconImageView.widthAnchor constraintEqualToConstant:24],
        [self.iconImageView.heightAnchor constraintEqualToConstant:24],
        [self.iconImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-16],

        [self.titleLabel.leftAnchor constraintEqualToAnchor:self.iconImageView.rightAnchor constant:8],
        [self.titleLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-16],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.iconImageView.centerYAnchor],
        [self.titleLabel.heightAnchor constraintGreaterThanOrEqualToConstant:24]
    ]];

    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexString:@"#E6E8EB"].CGColor;
}

- (void)setMessageTitle:(NSString *)title {
    self.titleLabel.text = title;
}

#pragma mark - lazy load

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_icon"]];
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:400];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#293138"];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

@end
