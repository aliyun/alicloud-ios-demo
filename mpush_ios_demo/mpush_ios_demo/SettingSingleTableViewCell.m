//
//  SettingSingleTableViewCell.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/21.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "SettingSingleTableViewCell.h"

@interface SettingSingleTableViewCell()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contentLabel;

@end

@implementation SettingSingleTableViewCell

+ (instancetype)cellWithType:(SettingSingleCellType)cellType {
    SettingSingleTableViewCell *cell = [[SettingSingleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingSingleTableViewCell"];
    [cell setCellType:cellType];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],

        [self.contentLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-10],
        [self.contentLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor]
    ]];

    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexString:@"#E6E8EB"].CGColor;
}

- (void)setCellType:(SettingSingleCellType)cellType {
    if (cellType == SettingSingleCellTypeAccount) {
        self.titleLabel.text = @"账号";
        self.contentLabel.text = @"未绑定账号";
    } else {
        self.titleLabel.text = @"角标数同步";
        self.contentLabel.text = @"未同步";
    }
}

- (void)setData:(NSString *)data {
    self.contentLabel.text = data;
}

#pragma mark - lazy load

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:500];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#1F2024"];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#999CA3"];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentLabel;
}

@end
