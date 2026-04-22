#import "EAPMDemoOverlayPresenter.h"

#import "EAPMDemoUIStyleGuide.h"

static UIColor *EAPMDemoOverlayHexColor(NSUInteger hexValue, CGFloat alpha) {
    return [UIColor colorWithRed:((hexValue >> 16) & 0xFF) / 255.0
                           green:((hexValue >> 8) & 0xFF) / 255.0
                            blue:(hexValue & 0xFF) / 255.0
                           alpha:alpha];
}

static CGFloat EAPMDemoBottomGuideButtonBottomSpacing(CGFloat safeAreaBottomInset) {
    return MAX(safeAreaBottomInset - 10.0, 12.0);
}

@interface EAPMDemoAlertViewController : UIViewController

- (instancetype)initWithTitleText:(NSString *)title
                          message:(NSString *)message
                 messageAlignment:(EAPMDemoAlertMessageAlignment)messageAlignment
                attributedMessage:(nullable NSAttributedString *)attributedMessage
                          actions:(NSArray<EAPMDemoAlertAction *> *)actions;

@end

@interface EAPMDemoBottomGuideViewController : UIViewController

- (instancetype)initWithTitleText:(NSString *)titleText
                       statusText:(NSString *)statusText
                       guideItems:(NSArray<NSString *> *)guideItems;

@end

@interface EAPMDemoAlertAction ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, assign, readwrite) EAPMDemoAlertActionStyle style;
@property (nonatomic, copy, readwrite, nullable) dispatch_block_t handler;

@end

@implementation EAPMDemoAlertAction

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(EAPMDemoAlertActionStyle)style
                        handler:(nullable dispatch_block_t)handler {
    EAPMDemoAlertAction *action = [[self alloc] init];
    action.title = title;
    action.style = style;
    action.handler = handler;
    return action;
}

@end

@implementation EAPMDemoAlertPresenter

+ (void)presentAlertFrom:(UIViewController *)presenter
                   title:(NSString *)title
                 message:(NSString *)message
                 actions:(NSArray<EAPMDemoAlertAction *> *)actions {
    [self presentAlertFrom:presenter
                     title:title
                   message:message
          messageAlignment:EAPMDemoAlertMessageAlignmentCenter
                   actions:actions];
}

+ (void)presentAlertFrom:(UIViewController *)presenter
                   title:(NSString *)title
                 message:(NSString *)message
        messageAlignment:(EAPMDemoAlertMessageAlignment)messageAlignment
                 actions:(NSArray<EAPMDemoAlertAction *> *)actions {
    [self presentAlertFrom:presenter
                     title:title
                   message:message
          messageAlignment:messageAlignment
        attributedMessage:nil
                   actions:actions];
}

+ (void)presentAlertFrom:(UIViewController *)presenter
                   title:(NSString *)title
       attributedMessage:(NSAttributedString *)attributedMessage
                 actions:(NSArray<EAPMDemoAlertAction *> *)actions {
    [self presentAlertFrom:presenter
                     title:title
                   message:attributedMessage.string ?: @""
          messageAlignment:EAPMDemoAlertMessageAlignmentLeft
        attributedMessage:attributedMessage
                   actions:actions];
}

+ (void)presentAlertFrom:(UIViewController *)presenter
                   title:(NSString *)title
                 message:(NSString *)message
        messageAlignment:(EAPMDemoAlertMessageAlignment)messageAlignment
      attributedMessage:(nullable NSAttributedString *)attributedMessage
                 actions:(NSArray<EAPMDemoAlertAction *> *)actions {
    if (!presenter || presenter.presentedViewController || actions.count == 0) {
        return;
    }

    EAPMDemoAlertViewController *viewController = [[EAPMDemoAlertViewController alloc] initWithTitleText:title
                                                                                                  message:message
                                                                                         messageAlignment:messageAlignment
                                                                                        attributedMessage:attributedMessage
                                                                                                  actions:actions];
    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [presenter presentViewController:viewController animated:YES completion:nil];
}

@end

@interface EAPMDemoAlertViewController ()

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, assign) EAPMDemoAlertMessageAlignment messageAlignment;
@property (nonatomic, copy, nullable) NSAttributedString *attributedMessageText;
@property (nonatomic, copy) NSArray<EAPMDemoAlertAction *> *actions;
@property (nonatomic, strong) UIVisualEffectView *backdropView;
@property (nonatomic, strong) UIView *dialogView;

@end

@implementation EAPMDemoAlertViewController

- (instancetype)initWithTitleText:(NSString *)title
                          message:(NSString *)message
                 messageAlignment:(EAPMDemoAlertMessageAlignment)messageAlignment
                attributedMessage:(nullable NSAttributedString *)attributedMessage
                          actions:(NSArray<EAPMDemoAlertAction *> *)actions {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _titleText = [title copy];
        _messageText = [message copy];
        _messageAlignment = messageAlignment;
        _attributedMessageText = [attributedMessage copy];
        _actions = [actions copy];
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.08];

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    self.backdropView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.backdropView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backdropView.alpha = 0.72;
    [self.view addSubview:self.backdropView];

    self.dialogView = [[UIView alloc] init];
    self.dialogView.translatesAutoresizingMaskIntoConstraints = NO;
    self.dialogView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    self.dialogView.layer.cornerRadius = EAPMDemoUIAlertCornerRadius;
    self.dialogView.layer.masksToBounds = YES;
    [self.view addSubview:self.dialogView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = EAPMDemoAlertTitleAttributedString(self.titleText, EAPMDemoOverlayHexColor(0x1B1D22, 1.0));
    [self.dialogView addSubview:titleLabel];

    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    messageLabel.numberOfLines = 0;
    NSTextAlignment textAlignment = self.messageAlignment == EAPMDemoAlertMessageAlignmentLeft ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    messageLabel.textAlignment = textAlignment;
    messageLabel.textColor = EAPMDemoOverlayHexColor(0x5B6472, 1.0);
    [self.dialogView addSubview:messageLabel];

    if (self.attributedMessageText.length > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = textAlignment;
        paragraphStyle.minimumLineHeight = 24.0;
        paragraphStyle.maximumLineHeight = 24.0;

        NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedMessageText];
        [messageText addAttributes:@{
            NSParagraphStyleAttributeName: paragraphStyle,
        } range:NSMakeRange(0, messageText.length)];
        messageLabel.attributedText = messageText;
    } else {
        messageLabel.attributedText = EAPMDemoAlertMessageAttributedString(self.messageText,
                                                                           EAPMDemoOverlayHexColor(0x5B6472, 1.0),
                                                                           textAlignment);
    }

    UIView *horizontalDivider = [[UIView alloc] init];
    horizontalDivider.translatesAutoresizingMaskIntoConstraints = NO;
    horizontalDivider.backgroundColor = EAPMDemoOverlayHexColor(0xE8EBF2, 1.0);
    [self.dialogView addSubview:horizontalDivider];

    UIStackView *buttonStackView = [[UIStackView alloc] init];
    buttonStackView.translatesAutoresizingMaskIntoConstraints = NO;
    buttonStackView.axis = UILayoutConstraintAxisHorizontal;
    buttonStackView.distribution = UIStackViewDistributionFillEqually;
    buttonStackView.alignment = UIStackViewAlignmentFill;
    [self.dialogView addSubview:buttonStackView];

    for (NSUInteger index = 0; index < self.actions.count; index++) {
        EAPMDemoAlertAction *action = self.actions[index];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setTitle:action.title forState:UIControlStateNormal];
        button.titleLabel.font = action.style == EAPMDemoAlertActionStylePrimary
            ? EAPMDemoUIFontSemibold(18.0)
            : EAPMDemoUIFontRegular(18.0);
        UIColor *titleColor = action.style == EAPMDemoAlertActionStylePrimary
            ? EAPMDemoOverlayHexColor(0x315CFC, 1.0)
            : EAPMDemoOverlayHexColor(0x9AA5B5, 1.0);
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        [button setTitleColor:[titleColor colorWithAlphaComponent:0.65] forState:UIControlStateHighlighted];
        button.tag = index;
        [button addTarget:self action:@selector(handleActionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [buttonStackView addArrangedSubview:button];
    }

    UIView *verticalDivider = nil;
    if (self.actions.count == 2) {
        verticalDivider = [[UIView alloc] init];
        verticalDivider.translatesAutoresizingMaskIntoConstraints = NO;
        verticalDivider.backgroundColor = EAPMDemoOverlayHexColor(0xE8EBF2, 1.0);
        [self.dialogView addSubview:verticalDivider];
    }

    CGFloat dialogWidth = MIN(CGRectGetWidth([UIScreen mainScreen].bounds) - 32.0, 344.0);

    [NSLayoutConstraint activateConstraints:@[
        [self.backdropView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.backdropView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.backdropView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.backdropView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [self.dialogView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.dialogView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.dialogView.widthAnchor constraintEqualToConstant:dialogWidth],

        [titleLabel.leadingAnchor constraintEqualToAnchor:self.dialogView.leadingAnchor constant:EAPMDemoUIAlertHorizontalInset],
        [titleLabel.trailingAnchor constraintEqualToAnchor:self.dialogView.trailingAnchor constant:-EAPMDemoUIAlertHorizontalInset],
        [titleLabel.topAnchor constraintEqualToAnchor:self.dialogView.topAnchor constant:EAPMDemoUIAlertTopInset],

        [messageLabel.leadingAnchor constraintEqualToAnchor:self.dialogView.leadingAnchor constant:EAPMDemoUIAlertHorizontalInset],
        [messageLabel.trailingAnchor constraintEqualToAnchor:self.dialogView.trailingAnchor constant:-EAPMDemoUIAlertHorizontalInset],
        [messageLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:EAPMDemoUIAlertTitleSpacing],

        [horizontalDivider.leadingAnchor constraintEqualToAnchor:self.dialogView.leadingAnchor],
        [horizontalDivider.trailingAnchor constraintEqualToAnchor:self.dialogView.trailingAnchor],
        [horizontalDivider.topAnchor constraintEqualToAnchor:messageLabel.bottomAnchor constant:EAPMDemoUIAlertButtonTopSpacing],
        [horizontalDivider.heightAnchor constraintEqualToConstant:1.0],

        [buttonStackView.leadingAnchor constraintEqualToAnchor:self.dialogView.leadingAnchor],
        [buttonStackView.trailingAnchor constraintEqualToAnchor:self.dialogView.trailingAnchor],
        [buttonStackView.topAnchor constraintEqualToAnchor:horizontalDivider.bottomAnchor],
        [buttonStackView.bottomAnchor constraintEqualToAnchor:self.dialogView.bottomAnchor],
        [buttonStackView.heightAnchor constraintEqualToConstant:EAPMDemoUIAlertButtonHeight],
    ]];

    if (verticalDivider) {
        [NSLayoutConstraint activateConstraints:@[
            [verticalDivider.centerXAnchor constraintEqualToAnchor:self.dialogView.centerXAnchor],
            [verticalDivider.topAnchor constraintEqualToAnchor:horizontalDivider.bottomAnchor],
            [verticalDivider.bottomAnchor constraintEqualToAnchor:self.dialogView.bottomAnchor],
            [verticalDivider.widthAnchor constraintEqualToConstant:1.0],
        ]];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)handleActionButtonTapped:(UIButton *)sender {
    if (sender.tag < 0 || sender.tag >= self.actions.count) {
        return;
    }

    EAPMDemoAlertAction *action = self.actions[sender.tag];
    [self dismissViewControllerAnimated:YES completion:^{
        if (action.handler) {
            action.handler();
        }
    }];
}

@end

@implementation EAPMDemoBottomGuidePresenter

+ (void)presentGuideFrom:(UIViewController *)presenter
                   title:(NSString *)title
              statusText:(NSString *)statusText
              guideItems:(NSArray<NSString *> *)guideItems {
    if (!presenter || presenter.presentedViewController) {
        return;
    }

    EAPMDemoBottomGuideViewController *viewController = [[EAPMDemoBottomGuideViewController alloc] initWithTitleText:title
                                                                                                             statusText:statusText
                                                                                                             guideItems:guideItems];
    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [presenter presentViewController:viewController animated:YES completion:nil];
}

@end

@interface EAPMDemoBottomGuideViewController ()

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *statusText;
@property (nonatomic, copy) NSArray<NSString *> *guideItems;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UIView *statusBackgroundView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) CAGradientLayer *statusGradientLayer;
@property (nonatomic, strong) CAGradientLayer *buttonGradientLayer;
@property (nonatomic, strong) NSLayoutConstraint *confirmButtonBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *panelTopConstraint;

@end

@implementation EAPMDemoBottomGuideViewController

- (instancetype)initWithTitleText:(NSString *)titleText
                       statusText:(NSString *)statusText
                       guideItems:(NSArray<NSString *> *)guideItems {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _titleText = [titleText copy];
        _statusText = [statusText copy];
        _guideItems = [guideItems copy];
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.18];

    UIVisualEffectView *backdropView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
    backdropView.translatesAutoresizingMaskIntoConstraints = NO;
    backdropView.alpha = 0.72;
    [self.view addSubview:backdropView];

    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    dismissButton.backgroundColor = UIColor.clearColor;
    [dismissButton addTarget:self action:@selector(handleDismissTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];

    self.panelView = [[UIView alloc] init];
    self.panelView.translatesAutoresizingMaskIntoConstraints = NO;
    self.panelView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.98];
    self.panelView.layer.cornerRadius = EAPMDemoUIBottomSheetCornerRadius;
    self.panelView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.panelView.layer.masksToBounds = YES;
    [self.view addSubview:self.panelView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = EAPMDemoBottomSheetTitleAttributedString(self.titleText,
                                                                         EAPMDemoOverlayHexColor(0x4B4D52, 1.0));
    [self.panelView addSubview:titleLabel];

    self.statusBackgroundView = [[UIView alloc] init];
    self.statusBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    self.statusBackgroundView.backgroundColor = EAPMDemoOverlayHexColor(0xDFF9DF, 1.0);
    self.statusBackgroundView.layer.cornerRadius = EAPMDemoUICornerRadius;
    self.statusBackgroundView.layer.masksToBounds = YES;
    self.statusGradientLayer = [CAGradientLayer layer];
    self.statusGradientLayer.colors = @[
        (__bridge id)EAPMDemoOverlayHexColor(0xD9F8D2, 1.0).CGColor,
        (__bridge id)EAPMDemoOverlayHexColor(0xD6F8E7, 1.0).CGColor,
    ];
    self.statusGradientLayer.startPoint = CGPointMake(0.0, 0.5);
    self.statusGradientLayer.endPoint = CGPointMake(1.0, 0.5);
    [self.statusBackgroundView.layer insertSublayer:self.statusGradientLayer atIndex:0];
    [self.panelView addSubview:self.statusBackgroundView];

    UIView *statusContentView = [[UIView alloc] init];
    statusContentView.translatesAutoresizingMaskIntoConstraints = NO;
    statusContentView.backgroundColor = UIColor.clearColor;
    [self.statusBackgroundView addSubview:statusContentView];

    UIImageView *statusIconView = [[UIImageView alloc] init];
    statusIconView.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 13.0, *)) {
        statusIconView.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
        statusIconView.tintColor = EAPMDemoOverlayHexColor(0x2DA45B, 1.0);
    }
    [statusContentView addSubview:statusIconView];

    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusLabel.text = self.statusText;
    statusLabel.textColor = EAPMDemoOverlayHexColor(0x2DA45B, 1.0);
    statusLabel.font = EAPMDemoUIFontMedium(15.0);
    [statusContentView addSubview:statusLabel];

    UIStackView *guideStackView = [[UIStackView alloc] init];
    guideStackView.translatesAutoresizingMaskIntoConstraints = NO;
    guideStackView.axis = UILayoutConstraintAxisVertical;
    guideStackView.spacing = EAPMDemoUIBottomSheetGuideSpacing;
    [self.panelView addSubview:guideStackView];

    BOOL showsStepIndex = self.guideItems.count > 1;
    [self.guideItems enumerateObjectsUsingBlock:^(NSString * _Nonnull guideItem, NSUInteger idx, BOOL * _Nonnull stop) {
        [guideStackView addArrangedSubview:[self guideRowWithText:guideItem index:(showsStepIndex ? idx + 1 : 0)]];
    }];

    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.confirmButton setTitle:@"我知道了" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = EAPMDemoUIFontSemibold(18.0);
    self.confirmButton.backgroundColor = EAPMDemoOverlayHexColor(0x4250F7, 1.0);
    self.confirmButton.layer.cornerRadius = EAPMDemoUICornerRadius;
    self.confirmButton.layer.masksToBounds = YES;
    [self.confirmButton addTarget:self action:@selector(handleDismissTapped) forControlEvents:UIControlEventTouchUpInside];
    self.buttonGradientLayer = [CAGradientLayer layer];
    self.buttonGradientLayer.colors = @[
        (__bridge id)EAPMDemoOverlayHexColor(0x4250F7, 1.0).CGColor,
        (__bridge id)EAPMDemoOverlayHexColor(0x435FF9, 1.0).CGColor,
    ];
    self.buttonGradientLayer.locations = @[@0, @1];
    self.buttonGradientLayer.startPoint = CGPointMake(1.0, 0.0);
    self.buttonGradientLayer.endPoint = CGPointMake(0.1, 1.0);
    [self.confirmButton.layer insertSublayer:self.buttonGradientLayer atIndex:0];
    [self.panelView addSubview:self.confirmButton];

    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    self.panelTopConstraint = [self.panelView.topAnchor constraintGreaterThanOrEqualToAnchor:safeArea.topAnchor constant:120.0];
    self.confirmButtonBottomConstraint = [self.confirmButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor
                                                                                        constant:-EAPMDemoBottomGuideButtonBottomSpacing(self.view.safeAreaInsets.bottom)];

    [NSLayoutConstraint activateConstraints:@[
        [backdropView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [backdropView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [backdropView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [backdropView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [dismissButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [dismissButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [dismissButton.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [dismissButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [self.panelView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.panelView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.panelView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        self.panelTopConstraint,

        [titleLabel.leadingAnchor constraintEqualToAnchor:self.panelView.leadingAnchor constant:EAPMDemoUIBottomSheetTitleInset],
        [titleLabel.trailingAnchor constraintEqualToAnchor:self.panelView.trailingAnchor constant:-EAPMDemoUIBottomSheetTitleInset],
        [titleLabel.topAnchor constraintEqualToAnchor:self.panelView.topAnchor constant:EAPMDemoUIBottomSheetTitleInset],

        [self.statusBackgroundView.leadingAnchor constraintEqualToAnchor:self.panelView.leadingAnchor constant:EAPMDemoUIBottomSheetHorizontalInset],
        [self.statusBackgroundView.trailingAnchor constraintEqualToAnchor:self.panelView.trailingAnchor constant:-EAPMDemoUIBottomSheetHorizontalInset],
        [self.statusBackgroundView.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:EAPMDemoUIBottomSheetStatusTopSpacing],
        [self.statusBackgroundView.heightAnchor constraintEqualToConstant:EAPMDemoUIBottomSheetStatusHeight],

        [statusContentView.centerXAnchor constraintEqualToAnchor:self.statusBackgroundView.centerXAnchor],
        [statusContentView.centerYAnchor constraintEqualToAnchor:self.statusBackgroundView.centerYAnchor],

        [statusIconView.leadingAnchor constraintEqualToAnchor:statusContentView.leadingAnchor],
        [statusIconView.centerYAnchor constraintEqualToAnchor:statusContentView.centerYAnchor],
        [statusIconView.widthAnchor constraintEqualToConstant:18.0],
        [statusIconView.heightAnchor constraintEqualToConstant:18.0],

        [statusLabel.leadingAnchor constraintEqualToAnchor:statusIconView.trailingAnchor constant:8.0],
        [statusLabel.trailingAnchor constraintEqualToAnchor:statusContentView.trailingAnchor],
        [statusLabel.centerYAnchor constraintEqualToAnchor:statusContentView.centerYAnchor],

        [guideStackView.leadingAnchor constraintEqualToAnchor:self.panelView.leadingAnchor constant:EAPMDemoUIBottomSheetHorizontalInset],
        [guideStackView.trailingAnchor constraintEqualToAnchor:self.panelView.trailingAnchor constant:-EAPMDemoUIBottomSheetHorizontalInset],
        [guideStackView.topAnchor constraintEqualToAnchor:self.statusBackgroundView.bottomAnchor constant:EAPMDemoUIBottomSheetGuideTopSpacing],
        [guideStackView.bottomAnchor constraintLessThanOrEqualToAnchor:self.confirmButton.topAnchor constant:-EAPMDemoUIBottomSheetButtonTopSpacing],

        [self.confirmButton.leadingAnchor constraintEqualToAnchor:self.panelView.leadingAnchor constant:EAPMDemoUIBottomSheetHorizontalInset],
        [self.confirmButton.trailingAnchor constraintEqualToAnchor:self.panelView.trailingAnchor constant:-EAPMDemoUIBottomSheetHorizontalInset],
        [self.confirmButton.topAnchor constraintGreaterThanOrEqualToAnchor:guideStackView.bottomAnchor constant:EAPMDemoUIBottomSheetButtonTopSpacing],
        [self.confirmButton.heightAnchor constraintEqualToConstant:EAPMDemoUIPrimaryButtonHeight],
        self.confirmButtonBottomConstraint,
    ]];
}

- (UIView *)guideRowWithText:(NSString *)text index:(NSUInteger)index {
    UIView *containerView = [[UIView alloc] init];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    textLabel.numberOfLines = 0;
    textLabel.attributedText = EAPMDemoBodyAttributedString(text, EAPMDemoOverlayHexColor(0x63728D, 1.0));
    [containerView addSubview:textLabel];

    if (index > 0) {
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.translatesAutoresizingMaskIntoConstraints = NO;
        indexLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)index];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.textColor = UIColor.whiteColor;
        indexLabel.font = EAPMDemoUIFontSemibold(12.0);
        indexLabel.backgroundColor = EAPMDemoOverlayHexColor(0x4D61FF, 1.0);
        indexLabel.layer.cornerRadius = 9.0;
        indexLabel.layer.masksToBounds = YES;
        [containerView addSubview:indexLabel];

        [NSLayoutConstraint activateConstraints:@[
            [indexLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor],
            [indexLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:2.0],
            [indexLabel.widthAnchor constraintEqualToConstant:18.0],
            [indexLabel.heightAnchor constraintEqualToConstant:18.0],

            [textLabel.leadingAnchor constraintEqualToAnchor:indexLabel.trailingAnchor constant:12.0],
            [textLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor],
            [textLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor],
            [textLabel.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor],
        ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
            [textLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor],
            [textLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor],
            [textLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor],
            [textLabel.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor],
        ]];
    }

    return containerView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.statusGradientLayer.frame = self.statusBackgroundView.bounds;
    self.statusGradientLayer.cornerRadius = self.statusBackgroundView.layer.cornerRadius;
    self.buttonGradientLayer.frame = self.confirmButton.bounds;
    self.buttonGradientLayer.cornerRadius = self.confirmButton.layer.cornerRadius;
    [self.panelView bringSubviewToFront:self.confirmButton];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    self.confirmButtonBottomConstraint.constant = -EAPMDemoBottomGuideButtonBottomSpacing(self.view.safeAreaInsets.bottom);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)handleDismissTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
