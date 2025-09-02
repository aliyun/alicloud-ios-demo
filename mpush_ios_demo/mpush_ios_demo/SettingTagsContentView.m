//
//  SettingTagsContentView.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/24.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "SettingTagsContentView.h"
#import "AliasAndTagView.h"

@interface SettingTagsContentView()

@property (nonatomic, copy) NSArray<SettingTag *> *tags;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIButton *showAllButton;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIView *line;

@end

@implementation SettingTagsContentView

- (instancetype)initWithTitle:(NSString *)title Tags:(NSArray<SettingTag *> *)tags {
    if (self = [super init]) {
        self.tags = tags;
        self.title = title;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"#999CA3"];
    titleLabel.text = self.title;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:titleLabel];

    [self addSubview:self.showAllButton];

    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:16],
        [titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:12],

        [self.showAllButton.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-16],
        [self.showAllButton.centerYAnchor constraintEqualToAnchor:titleLabel.centerYAnchor],
        [self.showAllButton.widthAnchor constraintEqualToConstant:80],
        [self.showAllButton.heightAnchor constraintEqualToConstant:36]
    ]];

    [self setupTags];

    self.line = [[UIView alloc] init];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.03];
    [self addSubview:self.line];
    [NSLayoutConstraint activateConstraints:@[
        [self.line.leftAnchor constraintEqualToAnchor:titleLabel.leftAnchor],
        [self.line.rightAnchor constraintEqualToAnchor:self.showAllButton.rightAnchor],
        [self.line.heightAnchor constraintEqualToConstant:1],
        [self.line.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)setupTags {
    if (self.tags.count <= 0) {
        return;
    }

    if (self.tags.count >= 9) {
        self.showAllButton.hidden = NO;
    }

    CGFloat tagViewWidth = ([UIScreen mainScreen].bounds.size.width - 32 - 32 - 16) / 3;
    for (int i = 0; i < self.tags.count; i++) {
        if (i >= 9) {
            return;
        }

        AliasAndTagView *tagView = [[AliasAndTagView alloc] initWithType:ViewTypeAliasAndTag title:self.tags[i].tagName];
        tagView.translatesAutoresizingMaskIntoConstraints = NO;
        __weak typeof(self) weakSelf = self;
        tagView.deleteHandle = ^(NSString * _Nonnull content) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf.deleteHandle) {
                strongSelf.deleteHandle(self.tags[i]);
            }
        };
        [self addSubview:tagView];

        NSInteger scalY = i / 3;
        NSInteger scalX = i % 3;
        [NSLayoutConstraint activateConstraints:@[
            [tagView.widthAnchor constraintEqualToConstant:tagViewWidth],
            [tagView.heightAnchor constraintEqualToConstant:36],
            [tagView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:16 + scalX * (tagViewWidth + 8)],
            [tagView.topAnchor constraintEqualToAnchor:self.topAnchor constant:40 + scalY * (36 + 8)]
        ]];

        if (i == 8 || i == self.tags.count - 1) {
            self.height = 40 + scalY * (36 + 8) + 36 + 12;
            [NSLayoutConstraint activateConstraints:@[
                [tagView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-12]
            ]];
            return;
        }
    }
}

- (void)showAllTagsAction {
    if (self.showAllHandle) {
        self.showAllHandle();
    }
}

- (CGFloat)getContentViewHeight {
    return _height;
}

- (void)hiddenLine {
    [self.line setHidden:YES];
}

#pragma mark - lazy load

- (UIButton *)showAllButton {
    if (!_showAllButton) {
        _showAllButton = [[UIButton alloc] init];
        [_showAllButton setTitle:@"查看全部" forState:UIControlStateNormal];
        [_showAllButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        _showAllButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_showAllButton setTitleColor:[UIColor colorWithHexString:@"#999CA3"] forState:UIControlStateNormal];
        [_showAllButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [_showAllButton addTarget:self action:@selector(showAllTagsAction) forControlEvents:UIControlEventTouchUpInside];
        _showAllButton.hidden = YES;
        _showAllButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _showAllButton;
}

@end
