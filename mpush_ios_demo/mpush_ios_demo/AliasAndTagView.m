//
//  AliasAndTagView.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/22.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "AliasAndTagView.h"

@interface AliasAndTagView()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *iconImageView;

@property (nonatomic, assign)ViewType type;
@property (nonatomic, copy)NSString *title;

@end

@implementation AliasAndTagView

- (instancetype)initWithType:(ViewType)type title:(nullable NSString *)title {
    if (self = [super init]) {
        self.type = type;
        self.title = title;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    switch (self.type) {
        case ViewTypeAddAlias:
            self.titleLabel.text = @"添加别名";
            break;
        case ViewTypeAddTag:
            self.titleLabel.text = @"添加标签";
            break;
        case ViewTypeAliasAndTag:
            self.titleLabel.text = self.title;
            self.titleLabel.textColor = [UIColor colorWithHexString:@"#424FF7"];
            self.iconImageView.image = [UIImage imageNamed:@"icon_delete"];
            break;
    }

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

    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAction)];
    [self addGestureRecognizer:viewTap];

    self.backgroundColor = [UIColor colorWithHexString:@"#EFF1F6"];
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithHexString:@"#EFF1F6"].CGColor;
}

#pragma mark - action

- (void)addAction {
    if (self.type == ViewTypeAliasAndTag) {
        return;
    }
    if (self.addHandle) {
        self.addHandle();
    }
}

- (void)deleteAction {
    if (self.type != ViewTypeAliasAndTag) {
        return;
    }

    // 如果单独设置了别名的值，说明是别名标签，需要把别名和标签一起回调出去
    if (self.alias.length > 0) {
        if (self.deleteAliasTagHandle) {
            self.deleteAliasTagHandle(self.alias, self.title);
        }
    } else {
        // 没有单独设置别名的值，可能是别名、可能是设备标签、账号标签
        if (self.deleteHandle) {
            self.deleteHandle(self.title);
        }
    }
}

#pragma mark - lazy load

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:400];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#4B4D52"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_add"]];
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
        UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAction)];
        [_iconImageView addGestureRecognizer:deleteTap];
        _iconImageView.userInteractionEnabled = YES;
    }
    return _iconImageView;
}

@end
