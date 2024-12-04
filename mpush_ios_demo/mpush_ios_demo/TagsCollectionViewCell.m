//
//  TagsCollectionViewCell.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/11/1.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "TagsCollectionViewCell.h"

@interface TagsCollectionViewCell()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *iconImageView;

@property (nonatomic, strong)SettingTag *bindTag;

@end

@implementation TagsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setTag:(SettingTag *)tag {
    self.bindTag = tag;
    self.titleLabel.text = tag.tagName;
}

- (void)setAlias:(NSString *)alias {
    self.titleLabel.text = alias;
    self.bindTag = nil;
}

- (void)setupSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];

    [NSLayoutConstraint activateConstraints:@[
        [self.iconImageView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-8],
        [self.iconImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.iconImageView.widthAnchor constraintEqualToConstant:16],
        [self.iconImageView.heightAnchor constraintEqualToConstant:16],

        [self.titleLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:8],
        [self.titleLabel.rightAnchor constraintEqualToAnchor:self.iconImageView.leftAnchor],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
    ]];

    self.backgroundColor = [UIColor colorWithHexString:@"#EFF1F6"];
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithHexString:@"#EFF1F6"].CGColor;
}

#pragma mark - action

- (void)deleteAction {
    if (self.bindTag) {
        if (self.deleteHandle) {
            self.deleteHandle(self.bindTag);
        }
    } else {
        if (self.deleteAliasHandle) {
            self.deleteAliasHandle(self.titleLabel.text);
        }
    }
}

#pragma mark - lazy load

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#424FF7"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_delete"]];
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
        UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAction)];
        [_iconImageView addGestureRecognizer:deleteTap];
        _iconImageView.userInteractionEnabled = YES;
    }
    return _iconImageView;
}

@end
