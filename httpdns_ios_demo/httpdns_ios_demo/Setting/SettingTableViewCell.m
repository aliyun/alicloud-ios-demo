//
//  SettingTableViewCell.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/29.
//

#import "SettingTableViewCell.h"

@interface SettingTableViewCell()<UITextFieldDelegate>

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *descriptionLabel;
@property(nonatomic, strong)UILabel *valueLabel;
@property(nonatomic, strong)UITextField *valueTextField;
@property(nonatomic, strong)UIImageView *valueImageView;

@property(nonatomic, assign)settingCellType cellType;

@end

@implementation SettingTableViewCell

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
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.valueTextField];

    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],

        [self.descriptionLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
        [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:8],

        [self.valueImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-5],
        [self.valueImageView.centerYAnchor constraintEqualToAnchor:self.valueLabel.centerYAnchor],
        [self.valueImageView.widthAnchor constraintEqualToConstant:16],
        [self.valueImageView.heightAnchor constraintEqualToConstant:16],

        [self.valueLabel.topAnchor constraintEqualToAnchor:self.titleLabel.topAnchor],
        [self.valueLabel.rightAnchor constraintEqualToAnchor:self.valueImageView.leftAnchor constant:-5],

        [self.valueTextField.rightAnchor constraintEqualToAnchor:self.valueLabel.leftAnchor constant:-5],
        [self.valueTextField.topAnchor constraintEqualToAnchor:self.valueLabel.topAnchor]
    ]];
}

- (void)setCellTitle:(NSString *)title description:(NSString *)description cellType:(settingCellType)cellType detailValue:(NSString *)value{
    self.titleLabel.text = title;
    self.descriptionLabel.text = description;
    self.cellType = cellType;

    if (cellType == RegionCell) {
        self.valueImageView.image = [UIImage imageNamed:@"Arrow_Down"];
        self.valueLabel.text = value;
    } else {
        self.valueImageView.image = [UIImage imageNamed:@"edit"];
        self.valueLabel.text = @"ms";
        self.valueTextField.text = value;
    }
}

- (void)detailValueChangedClick {
    if (self.cellType == RegionCell) {
        [self chooseRegion];
    } else {
        [self.valueTextField becomeFirstResponder];
    }
}

- (void)chooseRegion {
    UIAlertController *regionAlert = [UIAlertController alertControllerWithTitle:@"请选择region" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    __weak typeof(self) weakSelf = self;
    UIAlertAction *cnAction = [UIAlertAction actionWithTitle:@"中国大陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.valueLabel.text = @"中国大陆";
        if (strongSelf.valueChangedHandle) {
            strongSelf.valueChangedHandle(@"cn");
        }
    }];
    [regionAlert addAction:cnAction];

    UIAlertAction *hkAction = [UIAlertAction actionWithTitle:@"香港" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.valueLabel.text = @"香港";
        if (strongSelf.valueChangedHandle) {
            strongSelf.valueChangedHandle(@"hk");
        }
    }];
    [regionAlert addAction:hkAction];

    UIAlertAction *sgAction = [UIAlertAction actionWithTitle:@"新加坡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.valueLabel.text = @"新加坡";
        if (strongSelf.valueChangedHandle) {
            strongSelf.valueChangedHandle(@"sg");
        }
    }];
    [regionAlert addAction:sgAction];

    UIAlertAction *deAction = [UIAlertAction actionWithTitle:@"德国" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.valueLabel.text = @"德国";
        if (strongSelf.valueChangedHandle) {
            strongSelf.valueChangedHandle(@"de");
        }
    }];
    [regionAlert addAction:deAction];

    UIAlertAction *usAction = [UIAlertAction actionWithTitle:@"美国" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.valueLabel.text = @"美国";
        if (strongSelf.valueChangedHandle) {
            strongSelf.valueChangedHandle(@"us");
        }
    }];
    [regionAlert addAction:usAction];

    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [regionAlert addAction:cancleAction];

    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:regionAlert animated:YES completion:nil];
}

- (void)restoreDefaultSettings {
    if (self.cellType == RegionCell) {
        self.valueLabel.text = @"中国大陆";
        self.valueChangedHandle(@"cn");
    } else {
        self.valueTextField.text = @"2000";
        self.valueChangedHandle(@"2000");
    }
}

#pragma mark - textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([HTTPDNSDemoTools isValidString:textField.text]) {
        if (self.valueChangedHandle) {
            self.valueChangedHandle(textField.text);
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:nonNumberSet] componentsJoinedByString:@""];

    return [string isEqualToString:filtered];
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

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = [UIFont systemFontOfSize:16];
        _valueLabel.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailValueChangedClick)];
        [_valueLabel addGestureRecognizer:tap];
        _valueLabel.userInteractionEnabled = YES;
    }
    return _valueLabel;
}

- (UITextField *)valueTextField {
    if (!_valueTextField) {
        _valueTextField = [[UITextField alloc] init];
        _valueTextField.font = [UIFont systemFontOfSize:16];
        _valueTextField.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
        _valueTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _valueTextField.delegate = self;
    }
    return _valueTextField;
}

- (UIImageView *)valueImageView {
    if (!_valueImageView) {
        _valueImageView = [[UIImageView alloc] init];
        _valueImageView.translatesAutoresizingMaskIntoConstraints = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailValueChangedClick)];
        [_valueImageView addGestureRecognizer:tap];
        _valueImageView.userInteractionEnabled = YES;
    }
    return _valueImageView;
}

@end
