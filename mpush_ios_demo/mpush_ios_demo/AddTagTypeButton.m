//
//  AddTagTypeButton.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/30.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "AddTagTypeButton.h"

@interface AddTagTypeButton()

@property (nonatomic, strong)UIImageView *selectedIcon;

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UILabel *valueLabel;

@property (nonatomic, strong)UIImageView *arrow;

@end

@implementation AddTagTypeButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubViews];
}

- (void)setupSubViews {
    [self addSubview:self.selectedIcon];
    [self addSubview:self.nameLabel];
    [self addSubview:self.valueLabel];
    [self addSubview:self.arrow];

    [NSLayoutConstraint activateConstraints:@[
        [self.selectedIcon.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:16],
        [self.selectedIcon.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.selectedIcon.widthAnchor constraintEqualToConstant:14],
        [self.selectedIcon.heightAnchor constraintEqualToConstant:14],

        [self.nameLabel.leftAnchor constraintEqualToAnchor:self.selectedIcon.rightAnchor constant:8],
        [self.nameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],

        [self.valueLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-33],
        [self.valueLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],

        [self.arrow.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-9],
        [self.arrow.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.arrow.widthAnchor constraintEqualToConstant:20],
        [self.arrow.heightAnchor constraintEqualToConstant:20],
    ]];
}

- (void)setName:(NSString *)name hasArrow:(BOOL)hasArrow {
    self.nameLabel.text = name;
    self.arrow.hidden = !hasArrow;
}

- (void)setValue:(NSString *)value {
    self.valueLabel.text = value;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.selectedIcon.highlighted = selected;
}

#pragma mark - lazy load

- (UIImageView *)selectedIcon {
    if (!_selectedIcon) {
        _selectedIcon = [[UIImageView alloc] init];
        _selectedIcon.image = [UIImage imageNamed:@"tagType_noSelected"];
        _selectedIcon.highlightedImage = [UIImage imageNamed:@"tagType_selected"];
        _selectedIcon.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _selectedIcon;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#4B4D52"];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _nameLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = [UIFont systemFontOfSize:14];
        _valueLabel.textColor = [UIColor colorWithHexString:@"#999CA3"];
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _valueLabel;
}

- (UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
        _arrow.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _arrow;
}

@end
