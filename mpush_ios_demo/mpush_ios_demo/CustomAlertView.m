//
//  CustomAlertView.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/16.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "CustomAlertView.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "CustomToastUtil.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define RH(value) kScreenHeight * value/812.0
#define RW(value) kScreenWidth * value/375.0

@interface CustomAlertView()

@property(nonatomic, strong)UIVisualEffectView *blurEffectView;
@property (nonatomic, assign)AlertInputType inputType;
@property (nonatomic, strong)UITextField *inputTextField;
@property (nonatomic, copy)InputHandle inputHandle;

@property (nonatomic, strong)UIButton *cancleButton;
@property (nonatomic, strong)UIButton *closeButton;

@end

@implementation CustomAlertView

#pragma mark 限制说明弹框

+ (void)showLimitNoteAlertView {
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithLimitNote];
    [alertView show];
}

- (instancetype)initWithLimitNote {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        [self setupLimitNoteViews];
    }
    return self;
}

- (void)setupLimitNoteViews {
    // 添加模糊效果
    [self addSubview:self.blurEffectView];

    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - RH(500), kScreenWidth, RH(500))];
    backgroundView.layer.cornerRadius = RH(12);
    backgroundView.backgroundColor = UIColor.whiteColor;
    [self addSubview:backgroundView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"限制说明";
    titleLabel.font = [UIFont systemFontOfSize:18 weight:500];
    titleLabel.textColor = [UIColor colorWithHexString:@"#4B4D52"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:titleLabel];

    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"icon_pop_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:closeButton];

    UITextView *contentTextView = [[UITextView alloc] init];
    contentTextView.editable = NO;
    contentTextView.showsVerticalScrollIndicator = NO;
    contentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:contentTextView];

    NSString *text = @"标签（tag）\n • App最多支持定义1万个标签，单个标签支持的最大长度为128字符。\n • 不建议在单个标签上绑定超过十万级设备，否则，发起对该标签的推送可能需要较长的处理时间，无法保障响应速度。此种情况下，建议您采用全推方式，或将设备集合拆分到更细粒度的标签，多次调用推送接口分别推送给这些标签来避免此问题。\n\n别名（alias）\n • 单个设备最多添加128个别名，同一个别名最多可被添加到128个设备。\n • 别名支持的最大长度为128字节。";

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    paragraphStyle.paragraphSpacing = 10;
    paragraphStyle.headIndent = 14;
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName: paragraphStyle,
        NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#4B4D52"],
        NSFontAttributeName: [UIFont systemFontOfSize:14]
    };

    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];

    [contentAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16 weight:500],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#4B4D52"]} range:[text rangeOfString:@"标签（tag）"]];
    [contentAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16 weight:500],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#4B4D52"]} range:[text rangeOfString:@"别名（alias）"]];
    // 设置蓝色圆点
    NSRange searchRange = NSMakeRange(0, contentAttributedString.length);
    NSString *dotCharacter = @"•";
    while (YES) {
        NSRange range = [contentAttributedString.mutableString rangeOfString:dotCharacter options:NSCaseInsensitiveSearch range:searchRange];

        if (range.location != NSNotFound) {
            [contentAttributedString addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#4154F7"], NSFontAttributeName: [UIFont systemFontOfSize:18]} range:range];
            searchRange = NSMakeRange(NSMaxRange(range), contentAttributedString.length - NSMaxRange(range));
        } else {
            break;
        }
    }
    contentTextView.attributedText = contentAttributedString;

    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.centerXAnchor constraintEqualToAnchor:backgroundView.centerXAnchor],
        [titleLabel.topAnchor constraintEqualToAnchor:backgroundView.topAnchor constant:RH(20)],

        [closeButton.rightAnchor constraintEqualToAnchor:backgroundView.rightAnchor constant:-16],
        [closeButton.centerYAnchor constraintEqualToAnchor:titleLabel.centerYAnchor],
        [closeButton.widthAnchor constraintEqualToConstant:RW(18)],
        [closeButton.heightAnchor constraintEqualToConstant:RW(18)],

        [contentTextView.leftAnchor constraintEqualToAnchor:backgroundView.leftAnchor constant:16],
        [contentTextView.rightAnchor constraintEqualToAnchor:backgroundView.rightAnchor constant:-16],
        [contentTextView.bottomAnchor constraintEqualToAnchor:backgroundView.bottomAnchor constant:RH(-20)],
        [contentTextView.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:RH(35)]
    ]];
}

#pragma mark - 设备标签/别名/绑定账号/角标同步 弹框

+ (void)showInputAlert:(AlertInputType)type handle:(InputHandle)handle {
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithType:type handle:handle];
    [alertView show];
}

- (instancetype)initWithType:(AlertInputType)type handle:(InputHandle)handle {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        [self setupInputViewsWithType:type];
        self.inputHandle = handle;
    }
    return self;
}

- (void)setupInputViewsWithType:(AlertInputType)type {
    // 添加模糊效果
    [self addSubview:self.blurEffectView];

    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - RH(320), kScreenWidth, RH(320))];
    backgroundView.layer.cornerRadius = RH(12);
    backgroundView.backgroundColor = UIColor.whiteColor;
    [self addSubview:backgroundView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:18 weight:500];
    titleLabel.textColor = [UIColor colorWithHexString:@"#293138"];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundView addSubview:titleLabel];

    [backgroundView addSubview:self.inputTextField];

    self.cancleButton = [[UIButton alloc] init];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:[UIColor colorWithHexString:@"#4e5970"] forState:UIControlStateNormal];
    [self.cancleButton setBackgroundColor:[UIColor colorWithHexString:@"#EBF0FF"]];
    self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.cancleButton.layer.cornerRadius = 8;
    [self.cancleButton addTarget:self action:@selector(cancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.cancleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundView addSubview:self.cancleButton];

    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [confirmButton setBackgroundColor:[UIColor colorWithHexString:@"#424FF7"]];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmButton.layer.cornerRadius = 8;
    [confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundView addSubview:confirmButton];

    switch (type) {
        case AlertInputTypeBindAlias:
            titleLabel.text = @"添加别名";
            self.inputTextField.placeholder = @"请输入别名";
            break;
        case AlertInputTypeBindAccount:
            titleLabel.text = @"绑定账号";
            self.inputTextField.placeholder = @"请输入账号";
            break;
        case AlertInputTypeSyncBadgeNum:
            titleLabel.text = @"角标数同步";
            self.inputTextField.placeholder = @"请输入角标数";
            self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default:
            break;
    }

    UILabel *description = [[UILabel alloc] init];
    description.font = [UIFont systemFontOfSize:14];
    description.textColor = [UIColor colorWithHexString:@"#999CA3"];
    description.textAlignment = NSTextAlignmentLeft;
    description.text = @"单个别名最大长度不超过128字节";
    description.hidden = YES;
    description.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundView addSubview:description];

    if (type != AlertInputTypeSyncBadgeNum) {
        NSLayoutConstraint *centerXConstraint = [titleLabel.centerXAnchor constraintEqualToAnchor:backgroundView.centerXAnchor];
        centerXConstraint.active = YES;
        if (type == AlertInputTypeBindAlias) {
            description.hidden = NO;
        }

        // 关闭按钮
        self.closeButton = [[UIButton alloc] init];
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"icon_pop_close"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
        [backgroundView addSubview:self.closeButton];

        [NSLayoutConstraint activateConstraints:@[
            [self.closeButton.rightAnchor constraintEqualToAnchor:backgroundView.rightAnchor constant:-16],
            [self.closeButton.topAnchor constraintEqualToAnchor:backgroundView.topAnchor constant:23],
            [self.closeButton.widthAnchor constraintEqualToConstant:RW(18)],
            [self.closeButton.heightAnchor constraintEqualToConstant:RW(18)]
        ]];
    } else {
        NSLayoutConstraint *leftConstraint = [titleLabel.leftAnchor constraintEqualToAnchor:backgroundView.leftAnchor constant:16];
        leftConstraint.active = YES;
    }

    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:backgroundView.topAnchor constant:RH(20)],

        [self.inputTextField.leftAnchor constraintEqualToAnchor:backgroundView.leftAnchor constant:16],
        [self.inputTextField.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:RH(20)],
        [self.inputTextField.rightAnchor constraintEqualToAnchor:backgroundView.rightAnchor constant:-16],
        [self.inputTextField.heightAnchor constraintEqualToConstant:RW(56)],

        [description.leftAnchor constraintEqualToAnchor:self.inputTextField.leftAnchor],
        [description.topAnchor constraintEqualToAnchor:self.inputTextField.bottomAnchor constant:2],

        [self.cancleButton.leftAnchor constraintEqualToAnchor:self.inputTextField.leftAnchor],
        [self.cancleButton.bottomAnchor constraintEqualToAnchor:backgroundView.bottomAnchor constant:RH(-32)],
        [self.cancleButton.widthAnchor constraintEqualToConstant:RW(167)],
        [self.cancleButton.heightAnchor constraintEqualToConstant:RW(52)],

        [confirmButton.widthAnchor constraintEqualToAnchor:self.cancleButton.widthAnchor],
        [confirmButton.heightAnchor constraintEqualToAnchor:self.cancleButton.heightAnchor],
        [confirmButton.centerYAnchor constraintEqualToAnchor:self.cancleButton.centerYAnchor],
        [confirmButton.rightAnchor constraintEqualToAnchor:backgroundView.rightAnchor constant:-16]
    ]];

    // 添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    NSString *bindAccount = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_BINDACCOUNT] ?: @"";
    if (type == AlertInputTypeBindAccount && bindAccount.length > 0) {
        [self setupAccountConfig:bindAccount];
    }
}

- (void)setupAccountConfig:(NSString *)account {
    self.inputTextField.backgroundColor = [UIColor colorWithHexString:@"#EFF1F6"];
    self.inputTextField.textColor = [UIColor colorWithHexString:@"#999CA3"];
    self.inputTextField.text = account;
    self.inputTextField.enabled = NO;

    [self.cancleButton setTitle:@"解除绑定" forState:UIControlStateNormal];
}

- (UIView *)createPaddingView {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, RW(56))];
    return paddingView;
}

- (void)cancleButtonAction {
    if (self.inputTextField.isEnabled) {
        [self close];
        return;
    }

    [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (res.success) {
                [CustomToastUtil showToastWithMessage:@"解绑成功" isSuccess:YES];
                self.inputTextField.enabled = YES;
                self.inputTextField.text = @"";
                self.inputTextField.textColor = [UIColor colorWithHexString:@"#4B4D52"];
                self.inputTextField.backgroundColor = UIColor.whiteColor;
                self.inputHandle(self.inputTextField.text);

                [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];

                [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEVICE_BINDACCOUNT];
            } else {
                [CustomToastUtil showToastWithMessage:@"解绑失败" isSuccess:NO];
            }
        });
    }];
}

- (void)confirmButtonAction {
    if (!self.inputTextField.isEnabled) {
        [CustomToastUtil showToastWithMessage:@"请先解绑" isSuccess:NO];
        return;
    }

    if (self.inputTextField.text.length <= 0) {
        [CustomToastUtil showToastWithMessage:@"未输入内容" isSuccess:NO];
        return;
    }
    self.inputHandle(self.inputTextField.text);
    [self close];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    CGSize keyboardSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    // 计算视图向上移动的高度
    CGFloat moveUpHeight = keyboardSize.height;

    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = -moveUpHeight;
        self.frame = frame;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 点击空白处隐藏键盘
    [self endEditing:YES];
}

#pragma mark - 弹框显示/关闭

- (void)close {
    [self removeFromSuperview];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}


#pragma mark - lazy load

-(UIVisualEffectView *)blurEffectView {
    if (!_blurEffectView) {
        // 创建模糊效果
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _blurEffectView.frame = self.bounds;
        _blurEffectView.alpha = 0.9;
    }
    return _blurEffectView;
}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.textColor = [UIColor colorWithHexString:@"#4B4D52"];
        _inputTextField.font = [UIFont systemFontOfSize:16];
        _inputTextField.layer.cornerRadius = 8;
        _inputTextField.layer.borderColor = [UIColor colorWithHexString:@"#E6E8EB"].CGColor;
        _inputTextField.layer.borderWidth = 1;
        _inputTextField.leftView = [self createPaddingView];
        _inputTextField.leftViewMode = UITextFieldViewModeAlways;
        _inputTextField.rightView = [self createPaddingView];
        _inputTextField.rightViewMode = UITextFieldViewModeAlways;
        _inputTextField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _inputTextField;
}

@end
