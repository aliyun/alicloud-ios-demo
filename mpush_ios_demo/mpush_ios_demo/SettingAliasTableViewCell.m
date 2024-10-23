//
//  SettingAliasTableViewCell.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/21.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "SettingAliasTableViewCell.h"
#import "AliasAndTagView.h"

@interface SettingAliasTableViewCell()

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)NSLayoutConstraint *addViewLeftConstraint;
@property (nonatomic, strong)NSLayoutConstraint *addViewTopConstraint;
@property (nonatomic, strong)NSLayoutConstraint *addViewBottomConstraint;
@property (nonatomic, strong)AliasAndTagView *addAliasView;

@property (nonatomic, assign)CGFloat aliasViewWidth;

@end

@implementation SettingAliasTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.aliasViewWidth = ([UIScreen mainScreen].bounds.size.width - 32 - 32 - 16) / 3;

    [self.contentView addSubview:self.titleLabel];
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:16]
    ]];

    self.addAliasView = [[AliasAndTagView alloc] initWithType:ViewTypeAddAlias title:nil];
    self.addAliasView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.addAliasView];
    self.addViewTopConstraint = [self.addAliasView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:12];
    self.addViewLeftConstraint = [self.addAliasView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16];
    self.addViewBottomConstraint = [self.addAliasView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-16];
    [NSLayoutConstraint activateConstraints:@[
        self.addViewTopConstraint,
        self.addViewLeftConstraint,
        [self.addAliasView.widthAnchor constraintEqualToConstant:self.aliasViewWidth],
        [self.addAliasView.heightAnchor constraintEqualToConstant:36],
        self.addViewBottomConstraint
    ]];

    __weak typeof(self) weakSelf = self;
    self.addAliasView.addHandle = ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.addHandle) {
            strongSelf.addHandle();
        }
    };

    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexString:@"#E6E8EB"].CGColor;
}

- (void)setAlias:(NSArray *)aliasArray {
    if (aliasArray.count <= 0) {
        return;
    }

    if (aliasArray.count >= 9) {
        [NSLayoutConstraint deactivateConstraints:@[
            self.addViewTopConstraint,
            self.addViewLeftConstraint,
            self.addViewBottomConstraint
        ]];
        [self.addAliasView removeFromSuperview];
    }

    for (int i = 0; i < aliasArray.count; i++) {
        if (i >= 9) {
            return;
        }

        AliasAndTagView *aliasView = [[AliasAndTagView alloc] initWithType:ViewTypeAliasAndTag title:aliasArray[i]];
        aliasView.translatesAutoresizingMaskIntoConstraints = NO;
        __weak typeof(self) weakSelf = self;
        aliasView.deleteHandle = ^(NSString * _Nonnull content) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf.deleteHandle) {
                strongSelf.deleteHandle(aliasArray[i]);
            }

        };
        [self.contentView addSubview:aliasView];

        NSInteger scalY = i / 3;
        NSInteger scalX = i % 3;
        [NSLayoutConstraint activateConstraints:@[
            [aliasView.widthAnchor constraintEqualToConstant:self.aliasViewWidth],
            [aliasView.heightAnchor constraintEqualToConstant:36],
            [aliasView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16 + scalX * (self.aliasViewWidth + 8)],
            [aliasView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:12 + scalY * (36 + 8)]
        ]];

        if (i == 8) {
            [NSLayoutConstraint activateConstraints:@[
                [aliasView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-16]
            ]];
            return;
        }
    }

    // update addAliasView's layout
    [NSLayoutConstraint deactivateConstraints:@[
        self.addViewTopConstraint,
        self.addViewLeftConstraint
    ]];

    NSInteger scalY = aliasArray.count / 3;
    NSInteger scalX = aliasArray.count % 3;
    self.addViewLeftConstraint.constant = 16 + scalX * (self.aliasViewWidth + 8);
    self.addViewTopConstraint.constant = 12 + scalY * (36 + 8);
    [NSLayoutConstraint activateConstraints:@[
        self.addViewTopConstraint,
        self.addViewLeftConstraint
    ]];
}

#pragma mark - lazy load

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:500];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#1F2024"];
        _titleLabel.text = @"别名设置";
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

@end
