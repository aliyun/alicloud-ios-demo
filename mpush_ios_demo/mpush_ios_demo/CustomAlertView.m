//
//  CustomAlertView.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/16.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "CustomAlertView.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define RH(value) kScreenHeight * value/812.0
#define RW(value) kScreenWidth * value/375.0

@interface CustomAlertView()

@property(nonatomic, strong)UIVisualEffectView *blurEffectView;
@property (nonatomic, assign)AlertInputType inputType;
@property (nonatomic, strong)UITextField *inputTextField;
@property (nonatomic, copy)InputHandle inputHandle;

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
    contentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:contentTextView];

    NSString *text = @"标签（tag）\n • App最多支持定义1万个标签，单个标签支持的最大长度为129字符。\n • 不建议在单个标签上绑定超过十万级设备，否则，发起对该标签的推送可能需要较长的处理时间，无法保障响应速度。此种情况下，建议您采用全推方式，或将设备集合拆分到更细粒度的标签，多次调用推送接口分别推送给这些标签来避免此问题。\n\n别名（alias）\n • 单个设备最多添加128个别名，同一个别名最多可被添加到128个设备。\n • 别名支持的最大长度为128字节。";

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

    UIButton *cancleButton = [[UIButton alloc] init];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor colorWithHexString:@"#4e5970"] forState:UIControlStateNormal];
    [cancleButton setBackgroundColor:[UIColor colorWithHexString:@"#EBF0FF"]];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    cancleButton.layer.cornerRadius = 8;
    [cancleButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    cancleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundView addSubview:cancleButton];

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
            titleLabel.text = @"绑定别名";
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

    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.leftAnchor constraintEqualToAnchor:backgroundView.leftAnchor constant:16],
        [titleLabel.topAnchor constraintEqualToAnchor:backgroundView.topAnchor constant:RH(20)],

        [self.inputTextField.leftAnchor constraintEqualToAnchor:titleLabel.leftAnchor],
        [self.inputTextField.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:RH(20)],
        [self.inputTextField.rightAnchor constraintEqualToAnchor:backgroundView.rightAnchor constant:-16],
        [self.inputTextField.heightAnchor constraintEqualToConstant:RW(56)],

        [cancleButton.leftAnchor constraintEqualToAnchor:titleLabel.leftAnchor],
        [cancleButton.bottomAnchor constraintEqualToAnchor:backgroundView.bottomAnchor constant:RH(-32)],
        [cancleButton.widthAnchor constraintEqualToConstant:RW(167)],
        [cancleButton.heightAnchor constraintEqualToConstant:RW(52)],

        [confirmButton.widthAnchor constraintEqualToAnchor:cancleButton.widthAnchor],
        [confirmButton.heightAnchor constraintEqualToAnchor:cancleButton.heightAnchor],
        [confirmButton.centerYAnchor constraintEqualToAnchor:cancleButton.centerYAnchor],
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
}

- (UIView *)creatPaddingView {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, RW(56))];
    return paddingView;
}

- (void)confirmButtonAction {
    if (self.inputTextField.text.length <= 0) {
        NSLog(@"没有输入");
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
        _inputTextField.leftView = [self creatPaddingView];
        _inputTextField.leftViewMode = UITextFieldViewModeAlways;
        _inputTextField.rightView = [self creatPaddingView];
        _inputTextField.rightViewMode = UITextFieldViewModeAlways;
        _inputTextField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _inputTextField;
}

@end
