//
//  SettingTagTableViewCell.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/23.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "SettingTagTableViewCell.h"
#import "AliasAndTagView.h"
#import "SettingTagsContentView.h"

@interface SettingTagTableViewCell()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *addButton;

@property (nonatomic, strong)NSLayoutConstraint *addViewLeftConstraint;
@property (nonatomic, strong)NSLayoutConstraint *addViewTopConstraint;
@property (nonatomic, strong)NSLayoutConstraint *addViewBottomConstraint;
@property (nonatomic, strong)AliasAndTagView *addTagView;

@property (nonatomic, assign)CGFloat tagViewWidth;

@end

@implementation SettingTagTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.tagViewWidth = ([UIScreen mainScreen].bounds.size.width - 32 - 32 - 16) / 3;

    [self.contentView addSubview:self.titleLabel];
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:16]
    ]];

    [self.contentView addSubview:self.addButton];
    [NSLayoutConstraint activateConstraints:@[
        [self.addButton.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-16],
        [self.addButton.centerYAnchor constraintEqualToAnchor:self.titleLabel.centerYAnchor],
        [self.addButton.widthAnchor constraintEqualToConstant:80],
        [self.addButton.heightAnchor constraintEqualToConstant:36]
    ]];

    self.addTagView = [[AliasAndTagView alloc] initWithType:ViewTypeAddAlias title:nil];
    self.addTagView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.addTagView];
    self.addViewTopConstraint = [self.addTagView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:12];
    self.addViewLeftConstraint = [self.addTagView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16];
    self.addViewBottomConstraint = [self.addTagView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-16];
    [NSLayoutConstraint activateConstraints:@[
        self.addViewTopConstraint,
        self.addViewLeftConstraint,
        [self.addTagView.widthAnchor constraintEqualToConstant:self.tagViewWidth],
        [self.addTagView.heightAnchor constraintEqualToConstant:36],
        self.addViewBottomConstraint
    ]];

    __weak typeof(self) weakSelf = self;
    self.addTagView.addHandle = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf addAction];
    };

    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexString:@"#E6E8EB"].CGColor;
}

- (void)setTagsData:(NSDictionary *)data {
    NSArray *deviceTags = data[@"device"];
    NSArray *aliasTags = data[@"alias"];
    NSArray *accountTags = data[@"account"];
    if (deviceTags.count == 0 && aliasTags.count == 0 && accountTags.count == 0) {
        return;
    }

    [NSLayoutConstraint deactivateConstraints:@[
        self.addViewTopConstraint,
        self.addViewLeftConstraint,
        [self.addTagView.widthAnchor constraintEqualToConstant:self.tagViewWidth],
        [self.addTagView.heightAnchor constraintEqualToConstant:36],
        self.addViewBottomConstraint
    ]];
    [self.addTagView removeFromSuperview];
    self.addButton.hidden = NO;

    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    stackView.spacing = 0;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:stackView];

    CGFloat stackViewHeight = 0;
    if (deviceTags.count > 0) {
        SettingTagsContentView *deviceTagsView = [[SettingTagsContentView alloc] initWithTitle:@"设备标签" Tags:deviceTags];
        __weak typeof(self) weakSelf = self;
        deviceTagsView.deleteHandle = ^(SettingTag * _Nonnull tag) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf deleteTagAction:tag];
        };
        deviceTagsView.showAllHandle = ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf showAllAction:1];
        };
        CGFloat height = [deviceTagsView getContentViewHeight];
        [stackView addArrangedSubview:deviceTagsView];
        [NSLayoutConstraint activateConstraints:@[
            [deviceTagsView.heightAnchor constraintEqualToConstant:height]
        ]];
        stackViewHeight += height;
    }

    if (aliasTags.count > 0) {
        SettingTagsContentView *aliasTagsView = [[SettingTagsContentView alloc] initWithTitle:@"别名标签" Tags:aliasTags];
        __weak typeof(self) weakSelf = self;
        aliasTagsView.deleteHandle = ^(SettingTag * _Nonnull tag) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf deleteTagAction:tag];
        };
        aliasTagsView.showAllHandle = ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf showAllAction:3];
        };
        CGFloat height = [aliasTagsView getContentViewHeight];
        [stackView addArrangedSubview:aliasTagsView];
        [NSLayoutConstraint activateConstraints:@[
            [aliasTagsView.heightAnchor constraintEqualToConstant:height]
        ]];
        stackViewHeight += height;
    }

    if (accountTags.count > 0) {
        SettingTagsContentView *accountTagsView = [[SettingTagsContentView alloc] initWithTitle:@"账号标签" Tags:accountTags];
        __weak typeof(self) weakSelf = self;
        accountTagsView.deleteHandle = ^(SettingTag * _Nonnull tag) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf deleteTagAction:tag];
        };
        accountTagsView.showAllHandle = ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf showAllAction:2];
        };
        CGFloat height = [accountTagsView getContentViewHeight];
        [stackView addArrangedSubview:accountTagsView];
        [NSLayoutConstraint activateConstraints:@[
            [accountTagsView.heightAnchor constraintEqualToConstant:height]
        ]];
        stackViewHeight += height;
    }

    [NSLayoutConstraint activateConstraints:@[
        [stackView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:6],
        [stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-6],
        [stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [stackView.heightAnchor constraintEqualToConstant:stackViewHeight]
    ]];

    SettingTagsContentView *contentView = stackView.arrangedSubviews.lastObject;
    [contentView hiddenLine];
}

#pragma mark - action

- (void)addAction {
    if (self.addHandle) {
        self.addHandle();
    }
}

- (void)showAllAction:(int)tagType {
    if (self.showAllHandle) {
        self.showAllHandle(tagType);
    }
}

- (void)deleteTagAction:(SettingTag *)tag {
    if (self.deleteHandle) {
        self.deleteHandle(tag);
    }
}

#pragma mark - lazy load

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:500];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#1F2024"];
        _titleLabel.text = @"标签";
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton setTitle:@"添加标签 +" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor colorWithHexString:@"#315CFC"] forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:400];
        _addButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        _addButton.translatesAutoresizingMaskIntoConstraints = NO;
        _addButton.hidden = YES;
    }
    return _addButton;
}

@end
