#import "EAPMDemoUIComponents.h"

#import "EAPMDemoUIStyleGuide.h"

static UIColor *EAPMDemoUIPageTitleColor(void) {
    return EAPMDemoUIColor(0x4B4D52, 1.0);
}

static UIColor *EAPMDemoUIPrimaryTextColor(void) {
    return EAPMDemoUIColor(0x1F2024, 1.0);
}

static UIColor *EAPMDemoUISecondaryTextColor(void) {
    return EAPMDemoUIColor(0x9A9EA8, 1.0);
}

static UIColor *EAPMDemoUIPlaceholderColor(void) {
    return EAPMDemoUIColor(0xC8D0DD, 1.0);
}

static UIColor *EAPMDemoUIFieldBackgroundColor(BOOL editable) {
    return editable ? EAPMDemoUIColor(0xF0F2F5, 1.0) : EAPMDemoUIColor(0xE1E5EB, 1.0);
}

static UIColor *EAPMDemoUIFieldTextColor(BOOL editable) {
    return editable ? EAPMDemoUIColor(0x4B4D52, 1.0) : EAPMDemoUIColor(0x95A4C2, 1.0);
}

static UIColor *EAPMDemoUIPrimaryGradientStartColor(void) {
    return EAPMDemoUIColor(0x4250F7, 1.0);
}

static UIColor *EAPMDemoUIPrimaryGradientEndColor(void) {
    return EAPMDemoUIColor(0x435FF9, 1.0);
}

static UIColor *EAPMDemoUISecondaryActionBackgroundColor(void) {
    return EAPMDemoUIColor(0xF7F8FB, 1.0);
}

static UIColor *EAPMDemoUISecondaryActionBorderColor(void) {
    return EAPMDemoUIColor(0xE6E8EB, 1.0);
}

@interface EAPMDemoSecondaryPageHeaderView ()

@property (nonatomic, copy) dispatch_block_t backHandler;

@end

@implementation EAPMDemoSecondaryPageHeaderView

- (instancetype)initWithTitle:(NSString *)title backHandler:(dispatch_block_t)backHandler {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _backHandler = [backHandler copy];
        self.translatesAutoresizingMaskIntoConstraints = NO;

        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        backButton.translatesAutoresizingMaskIntoConstraints = NO;
        if (@available(iOS 13.0, *)) {
            UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:12.0 weight:UIImageSymbolWeightMedium];
            UIImage *image = [UIImage systemImageNamed:@"chevron.left" withConfiguration:configuration];
            [backButton setImage:image forState:UIControlStateNormal];
        } else {
            [backButton setTitle:@"返回" forState:UIControlStateNormal];
            backButton.titleLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
        }
        backButton.tintColor = EAPMDemoUIPrimaryTextColor();
        [backButton addTarget:self action:@selector(handleBackTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.numberOfLines = 1;
        titleLabel.attributedText = EAPMDemoPageTitleAttributedString(title, EAPMDemoUIPageTitleColor());
        [self addSubview:titleLabel];

        [NSLayoutConstraint activateConstraints:@[
            [backButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:EAPMDemoUIHorizontalInset],
            [backButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:EAPMDemoUIHeaderTopPadding],
            [backButton.widthAnchor constraintEqualToConstant:20.0],
            [backButton.heightAnchor constraintEqualToConstant:20.0],

            [titleLabel.leadingAnchor constraintEqualToAnchor:backButton.trailingAnchor constant:EAPMDemoUIHeaderTitleSpacing],
            [titleLabel.centerYAnchor constraintEqualToAnchor:backButton.centerYAnchor],

            [self.bottomAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:EAPMDemoUIHeaderBottomPadding],
        ]];
    }
    return self;
}

- (void)handleBackTapped {
    if (self.backHandler) {
        self.backHandler();
    }
}

@end

@interface EAPMDemoSectionHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation EAPMDemoSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *indicatorView = EAPMDemoCreateSectionIndicatorView(EAPMDemoUIColor(0x315CFC, 1.0));
        [self addSubview:indicatorView];

        _titleLabel = [[UILabel alloc] init];
        EAPMDemoConfigureSectionTitleLabel(_titleLabel, @"", EAPMDemoUIPageTitleColor());
        [self addSubview:_titleLabel];

        [NSLayoutConstraint activateConstraints:@[
            [indicatorView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [indicatorView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [indicatorView.widthAnchor constraintEqualToConstant:4.0],
            [indicatorView.heightAnchor constraintEqualToConstant:20.0],

            [_titleLabel.leadingAnchor constraintEqualToAnchor:indicatorView.trailingAnchor constant:12.0],
            [_titleLabel.centerYAnchor constraintEqualToAnchor:indicatorView.centerYAnchor],
            [_titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor],
        ]];
    }
    return self;
}

- (void)configureWithTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end

@interface EAPMDemoTipCardView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIColor *textColor;

@end

@implementation EAPMDemoTipCardView

- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor
                              textColor:(UIColor *)textColor
                            borderColor:(nullable UIColor *)borderColor {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = backgroundColor;
        self.layer.cornerRadius = EAPMDemoUICornerRadius;
        self.layer.masksToBounds = YES;
        self.textColor = textColor;
        if (borderColor) {
            self.layer.borderWidth = 1.0;
            self.layer.borderColor = borderColor.CGColor;
        }

        _textLabel = [[UILabel alloc] init];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.numberOfLines = 0;
        [_textLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_textLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self addSubview:_textLabel];

        [NSLayoutConstraint activateConstraints:@[
            [_textLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:EAPMDemoUIHorizontalInset],
            [_textLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
            [_textLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:EAPMDemoUITipCardVerticalInset],
            [_textLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-EAPMDemoUITipCardVerticalInset],
        ]];
    }
    return self;
}

- (void)configureWithText:(NSString *)text {
    [self configureWithAttributedText:EAPMDemoInfoAttributedString(text, self.textColor)];
}

- (void)configureWithAttributedText:(NSAttributedString *)attributedText {
    self.textLabel.attributedText = attributedText;
}

@end

@interface EAPMDemoInputFieldView ()

@property (nonatomic, strong, readwrite) UITextField *textField;
@property (nonatomic, assign) BOOL editable;

@end

@implementation EAPMDemoInputFieldView

- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
                     editable:(BOOL)editable {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _editable = editable;

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.numberOfLines = 1;
        titleLabel.attributedText = EAPMDemoFieldTitleAttributedString(title, EAPMDemoUISecondaryTextColor());
        [self addSubview:titleLabel];

        UIView *containerView = [[UIView alloc] init];
        containerView.translatesAutoresizingMaskIntoConstraints = NO;
        containerView.backgroundColor = EAPMDemoUIFieldBackgroundColor(editable);
        containerView.layer.cornerRadius = EAPMDemoUICornerRadius;
        [self addSubview:containerView];

        _textField = [[UITextField alloc] init];
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
        _textField.font = EAPMDemoUIFontRegular(16.0);
        _textField.textColor = EAPMDemoUIFieldTextColor(editable);
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:(placeholder ?: @"")
                                                                           attributes:@{
            NSFontAttributeName: EAPMDemoUIFontRegular(16.0),
            NSForegroundColorAttributeName: EAPMDemoUIPlaceholderColor(),
        }];
        _textField.enabled = editable;
        _textField.returnKeyType = editable ? UIReturnKeyNext : UIReturnKeyDone;
        _textField.clearButtonMode = editable ? UITextFieldViewModeWhileEditing : UITextFieldViewModeNever;
        [containerView addSubview:_textField];

        [NSLayoutConstraint activateConstraints:@[
            [titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor],

            [containerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [containerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [containerView.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:EAPMDemoUIFieldSpacing],
            [containerView.heightAnchor constraintEqualToConstant:EAPMDemoUIInputHeight],
            [containerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

            [_textField.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
            [_textField.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
            [_textField.topAnchor constraintEqualToAnchor:containerView.topAnchor],
            [_textField.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor],
        ]];
    }
    return self;
}

@end

@implementation EAPMDemoPrimaryButton {
    CAGradientLayer *_gradientLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.layer.cornerRadius = EAPMDemoUICornerRadius;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = EAPMDemoUIFontSemibold(18.0);
        [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];

        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[
            (__bridge id)EAPMDemoUIPrimaryGradientStartColor().CGColor,
            (__bridge id)EAPMDemoUIPrimaryGradientEndColor().CGColor,
        ];
        _gradientLayer.locations = @[@0, @1];
        _gradientLayer.startPoint = CGPointMake(1.0, 0.0);
        _gradientLayer.endPoint = CGPointMake(0.1, 1.0);
        [self.layer insertSublayer:_gradientLayer atIndex:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gradientLayer.frame = self.bounds;
    _gradientLayer.cornerRadius = self.layer.cornerRadius;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.alpha = enabled ? 1.0 : 0.55;
}

@end

@implementation EAPMDemoSecondaryActionButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        EAPMDemoApplySecondaryCardStyle(self,
                                        EAPMDemoUISecondaryActionBackgroundColor(),
                                        EAPMDemoUISecondaryActionBorderColor());
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)configureWithTitle:(NSString *)title {
    [self setAttributedTitle:EAPMDemoCenteredActionAttributedString(title, EAPMDemoUIPrimaryTextColor())
                    forState:UIControlStateNormal];
}

- (void)setActionHighlighted:(BOOL)highlighted {
    CGFloat alpha = highlighted ? 0.9 : 1.0;
    CGAffineTransform transform = highlighted ? CGAffineTransformMakeScale(0.98, 0.98) : CGAffineTransformIdentity;
    [UIView animateWithDuration:0.18 animations:^{
        self.alpha = alpha;
        self.transform = transform;
    }];
}

@end

@implementation EAPMDemoToastPresenter

+ (void)showToastInViewController:(UIViewController *)presenter message:(NSString *)message {
    if (!presenter || !presenter.view || message.length == 0) {
        return;
    }

    UIView *toastView = [[UIView alloc] init];
    toastView.translatesAutoresizingMaskIntoConstraints = NO;
    toastView.alpha = 0.0;
    toastView.backgroundColor = EAPMDemoUIColor(0x1E2A44, 0.96);
    toastView.layer.cornerRadius = 12.0;

    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    messageLabel.text = message;
    messageLabel.textColor = UIColor.whiteColor;
    messageLabel.font = EAPMDemoUIFontMedium(15.0);
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [toastView addSubview:messageLabel];
    [presenter.view addSubview:toastView];

    [NSLayoutConstraint activateConstraints:@[
        [toastView.centerXAnchor constraintEqualToAnchor:presenter.view.centerXAnchor],
        [toastView.bottomAnchor constraintEqualToAnchor:presenter.view.safeAreaLayoutGuide.bottomAnchor constant:-28.0],
        [toastView.leadingAnchor constraintGreaterThanOrEqualToAnchor:presenter.view.leadingAnchor constant:20.0],
        [messageLabel.leadingAnchor constraintEqualToAnchor:toastView.leadingAnchor constant:18.0],
        [messageLabel.trailingAnchor constraintEqualToAnchor:toastView.trailingAnchor constant:-18.0],
        [messageLabel.topAnchor constraintEqualToAnchor:toastView.topAnchor constant:12.0],
        [messageLabel.bottomAnchor constraintEqualToAnchor:toastView.bottomAnchor constant:-12.0],
    ]];

    toastView.transform = CGAffineTransformMakeTranslation(0.0, 8.0);
    [UIView animateWithDuration:0.22
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        toastView.alpha = 1.0;
        toastView.transform = CGAffineTransformIdentity;
    } completion:^(__unused BOOL finished) {
        [UIView animateWithDuration:0.2
                              delay:1.2
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            toastView.alpha = 0.0;
            toastView.transform = CGAffineTransformMakeTranslation(0.0, 6.0);
        } completion:^(__unused BOOL innerFinished) {
            [toastView removeFromSuperview];
        }];
    }];
}

@end
