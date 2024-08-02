//
//  SettingOtherTableViewCell.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/31.
//

#import "SettingOtherTableViewCell.h"

@interface SettingOtherTableViewCell()

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIImageView *iconImageView;
@property(nonatomic, strong)NSMutableArray *constraintsArray;

@end

@implementation SettingOtherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.iconImageView];

    self.constraintsArray = @[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor]
    ].mutableCopy;
    [NSLayoutConstraint activateConstraints:self.constraintsArray];
}

- (void)setCellType:(OtherCellType)cellType {
    switch (cellType) {
        case HelpCenterCell:
            self.titleLabel.text = @"帮助中心";
            [self.constraintsArray addObjectsFromArray:@[
                [self.iconImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
                [self.iconImageView.centerYAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor],
                [self.iconImageView.widthAnchor constraintEqualToConstant:28],
                [self.iconImageView.heightAnchor constraintEqualToConstant:28]
            ]];
            [NSLayoutConstraint activateConstraints:self.constraintsArray];

            self.iconImageView.image = [UIImage imageNamed:@"Arrow_RightUp"];
            break;
        case AboutUsCell:
            self.titleLabel.text = @"关于我们";
            [self.constraintsArray addObjectsFromArray:@[
                [self.iconImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
                [self.iconImageView.centerYAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor],
                [self.iconImageView.widthAnchor constraintEqualToConstant:7],
                [self.iconImageView.heightAnchor constraintEqualToConstant:12]
            ]];
            [NSLayoutConstraint activateConstraints:self.constraintsArray];

            self.iconImageView.image = [UIImage imageNamed:@"Arrow_Right"];
            break;
        case DefaultSettingCell:
            self.titleLabel.text = @"恢复默认设置";
            self.titleLabel.textColor = [UIColor colorWithHexString:@"#424FF7"];
            self.iconImageView.hidden = YES;
            break;
    }
}

#pragma mark - lazy load

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:500];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _iconImageView;
}

@end
