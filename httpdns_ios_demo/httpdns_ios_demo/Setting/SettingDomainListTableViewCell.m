//
//  SettingDomainListTableViewCell.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/31.
//

#import "SettingDomainListTableViewCell.h"

@interface SettingDomainListTableViewCell()

@property(nonatomic, strong)UILabel *domainLabel;
@property(nonatomic, strong)UIButton *checkBox;

@end

@implementation SettingDomainListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.domainLabel];
    [self.contentView addSubview:self.checkBox];

    [NSLayoutConstraint activateConstraints:@[
        [self.domainLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.domainLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor],
        [self.domainLabel.widthAnchor constraintLessThanOrEqualToConstant:200],
        
        [self.checkBox.centerYAnchor constraintEqualToAnchor:self.domainLabel.centerYAnchor],
        [self.checkBox.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-5],
        [self.checkBox.widthAnchor constraintEqualToConstant:21],
        [self.checkBox.heightAnchor constraintEqualToConstant:21]
    ]];
}

- (void)checkBoxClick {
    self.checkBox.selected = !self.checkBox.selected;

    if (self.selecetedHandle) {
        self.selecetedHandle(self.checkBox.selected);
    }
}

- (void)setDomain:(NSString *)domain isSelected:(BOOL)isSelected {
    self.domainLabel.text = domain;
    self.checkBox.selected = isSelected;
}

#pragma mark - lazy load

- (UILabel *)domainLabel {
    if (!_domainLabel) {
        _domainLabel = [[UILabel alloc] init];
        _domainLabel.font = [UIFont systemFontOfSize:16];
        _domainLabel.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
        _domainLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _domainLabel;
}

- (UIButton *)checkBox {
    if (!_checkBox) {
        _checkBox = [[UIButton alloc] init];
        [_checkBox setBackgroundImage:[UIImage imageNamed:@"CheckBox_NO"] forState:UIControlStateNormal];
        [_checkBox setBackgroundImage:[UIImage imageNamed:@"CheckBox_YES"] forState:UIControlStateSelected];
        _checkBox.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _checkBox;
}

@end
