//
//  SettingSwitchTableViewCell.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/25.
//

#import "SettingSwitchTableViewCell.h"

@interface SettingSwitchTableViewCell()

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *descriptionLabel;
@property(nonatomic, strong)UISwitch *settingSwitch;

@end

@implementation SettingSwitchTableViewCell

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
    [self.contentView addSubview:self.settingSwitch];

    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],

        [self.descriptionLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
        [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:8],

        [self.settingSwitch.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-5],
        [self.settingSwitch.centerYAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:4]
    ]];
}

- (void)setTitle:(NSString *)title description:(NSString *)description isOn:(BOOL)isOn {
    self.titleLabel.text = title;
    self.descriptionLabel.text = description;
    self.settingSwitch.on = isOn;
}

- (void)switchChanged:(UISwitch *)sender {
    self.switchChangedhandle(sender.isOn);
}

- (void)restoreDefaultSettings {
    self.settingSwitch.on = NO;
    self.switchChangedhandle(NO);
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

- (UISwitch *)settingSwitch {
    if (!_settingSwitch) {
        _settingSwitch = [[UISwitch alloc] init];
        _settingSwitch.thumbTintColor = [UIColor whiteColor];
        _settingSwitch.onTintColor = [UIColor colorWithHexString:@"#5578ED"];
        _settingSwitch.tintColor = [UIColor colorWithHexString:@"#E6EBF3"];
        [_settingSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        _settingSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _settingSwitch;
}

@end
