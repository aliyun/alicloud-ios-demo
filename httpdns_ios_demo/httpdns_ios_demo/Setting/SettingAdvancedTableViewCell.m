//
//  SettingAdvancedTableViewCell.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/30.
//

#import "SettingAdvancedTableViewCell.h"

@interface SettingAdvancedTableViewCell()

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *descriptionLabel;
@property(nonatomic, strong)UIImageView *valueImageView;

@end

@implementation SettingAdvancedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.valueImageView];

    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],

        [self.descriptionLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
        [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:8],

        [self.valueImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
        [self.valueImageView.centerYAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor],
        [self.valueImageView.widthAnchor constraintEqualToConstant:7],
        [self.valueImageView.heightAnchor constraintEqualToConstant:12]
    ]];
}

- (void)setTitle:(NSString *)title description:(NSString *)description {
    self.titleLabel.text = title;
    self.descriptionLabel.text = description;
}

#pragma mark - lazy load

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont systemFontOfSize:12];
        _descriptionLabel.textColor = [UIColor colorWithHexString:@"#98A4BA"];
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _descriptionLabel;
}

- (UIImageView *)valueImageView {
    if (!_valueImageView) {
        _valueImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow_Right"]];
        _valueImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _valueImageView.userInteractionEnabled = YES;
    }
    return _valueImageView;
}

@end
