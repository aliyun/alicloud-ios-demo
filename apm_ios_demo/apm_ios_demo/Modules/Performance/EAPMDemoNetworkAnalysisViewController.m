#import "EAPMDemoNetworkAnalysisViewController.h"

#import "../Shared/EAPMDemoOverlayPresenter.h"
#import "../Shared/EAPMDemoUIComponents.h"
#import "../Shared/EAPMDemoUIStyleGuide.h"

static NSString * const EAPMDemoNetworkAnalysisDefaultURLString = @"https://www.aliyun.com";
static NSString * const EAPMDemoNetworkAnalysisTransportErrorURLString = @"https://demo-network-error.invalid/";
static NSString * const EAPMDemoNetworkAnalysisHTTPErrorURLString = @"https://postman-echo.com/status/500";
static const CGFloat EAPMDemoNetworkAnalysisContentBottomPadding = 64.0;
static const CGFloat EAPMDemoNetworkAnalysisInputButtonSpacing = 12.0;
static const CGFloat EAPMDemoNetworkAnalysisErrorSectionTopSpacing = 32.0;

static UIColor *EAPMDemoNetworkAnalysisHexColor(NSUInteger hexValue, CGFloat alpha) {
    return [UIColor colorWithRed:((hexValue >> 16) & 0xFF) / 255.0
                           green:((hexValue >> 8) & 0xFF) / 255.0
                            blue:(hexValue & 0xFF) / 255.0
                           alpha:alpha];
}

@interface EAPMDemoNetworkAnalysisViewController () <UITextFieldDelegate>

@property (nonatomic, strong) EAPMDemoSecondaryPageHeaderView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITextField *urlTextField;
@property (nonatomic, strong) EAPMDemoPrimaryButton *sendButton;
@property (nonatomic, strong) EAPMDemoSecondaryActionButton *transportErrorButton;
@property (nonatomic, strong) EAPMDemoSecondaryActionButton *httpErrorButton;
@property (nonatomic, assign) BOOL requestInProgress;

@end

@implementation EAPMDemoNetworkAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"";
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = UIColor.whiteColor;

    [self buildViews];
    [self installDismissKeyboardGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)buildViews {
    __weak typeof(self) weakSelf = self;
    self.headerView = [[EAPMDemoSecondaryPageHeaderView alloc] initWithTitle:@"网络分析" backHandler:^{
        [weakSelf handleBackButtonTapped];
    }];
    [self.view addSubview:self.headerView];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];

    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.contentView];

    EAPMDemoTipCardView *tipCardView = [[EAPMDemoTipCardView alloc] initWithBackgroundColor:EAPMDemoNetworkAnalysisHexColor(0xEEF3FF, 1.0)
                                                                                   textColor:EAPMDemoNetworkAnalysisHexColor(0x7A8FB8, 1.0)
                                                                                 borderColor:nil];
    [tipCardView configureWithText:@"请触发不同类型的网络请求。网络分析数据在App退至后台时统一上报，稍后可在 EMAS 控制台查看。"];
    [self.contentView addSubview:tipCardView];

    EAPMDemoSectionHeaderView *requestSectionHeaderView = [[EAPMDemoSectionHeaderView alloc] init];
    requestSectionHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    [requestSectionHeaderView configureWithTitle:@"网络请求"];
    [self.contentView addSubview:requestSectionHeaderView];

    EAPMDemoInputFieldView *urlInputView = [[EAPMDemoInputFieldView alloc] initWithTitle:@"URL"
                                                                              placeholder:@"请输入完整URL，默认https://www.aliyun.com"
                                                                                 editable:YES];
    self.urlTextField = urlInputView.textField;
    self.urlTextField.keyboardType = UIKeyboardTypeURL;
    self.urlTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.urlTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.urlTextField.returnKeyType = UIReturnKeyGo;
    self.urlTextField.delegate = self;
    [self.contentView addSubview:urlInputView];

    self.sendButton = [EAPMDemoPrimaryButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setTitle:@"发送请求" forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(handleSendButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sendButton];

    EAPMDemoSectionHeaderView *errorSectionHeaderView = [[EAPMDemoSectionHeaderView alloc] init];
    errorSectionHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    [errorSectionHeaderView configureWithTitle:@"网络错误"];
    [self.contentView addSubview:errorSectionHeaderView];

    UIStackView *errorButtonStackView = [[UIStackView alloc] init];
    errorButtonStackView.translatesAutoresizingMaskIntoConstraints = NO;
    errorButtonStackView.axis = UILayoutConstraintAxisHorizontal;
    errorButtonStackView.alignment = UIStackViewAlignmentFill;
    errorButtonStackView.distribution = UIStackViewDistributionFillEqually;
    errorButtonStackView.spacing = 6.0;
    [self.contentView addSubview:errorButtonStackView];

    self.transportErrorButton = [self createErrorButtonWithTitle:@"网络错误" action:@selector(handleTransportErrorButtonTapped)];
    self.httpErrorButton = [self createErrorButtonWithTitle:@"HTTP错误" action:@selector(handleHTTPErrorButtonTapped)];
    [errorButtonStackView addArrangedSubview:self.transportErrorButton];
    [errorButtonStackView addArrangedSubview:self.httpErrorButton];

    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [self.headerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.headerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.headerView.topAnchor constraintEqualToAnchor:safeArea.topAnchor],

        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor],
        [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor],

        [tipCardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [tipCardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
        [tipCardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:EAPMDemoUIContentTopSpacing],

        [requestSectionHeaderView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [requestSectionHeaderView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
        [requestSectionHeaderView.topAnchor constraintEqualToAnchor:tipCardView.bottomAnchor constant:EAPMDemoUISectionTopSpacing],

        [urlInputView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [urlInputView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
        [urlInputView.topAnchor constraintEqualToAnchor:requestSectionHeaderView.bottomAnchor constant:EAPMDemoUISectionContentSpacing],

        [self.sendButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [self.sendButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
        [self.sendButton.topAnchor constraintEqualToAnchor:urlInputView.bottomAnchor constant:EAPMDemoNetworkAnalysisInputButtonSpacing],
        [self.sendButton.heightAnchor constraintEqualToConstant:EAPMDemoUIPrimaryButtonHeight],

        [errorSectionHeaderView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [errorSectionHeaderView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
        [errorSectionHeaderView.topAnchor constraintEqualToAnchor:self.sendButton.bottomAnchor constant:EAPMDemoNetworkAnalysisErrorSectionTopSpacing],

        [errorButtonStackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [errorButtonStackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
        [errorButtonStackView.topAnchor constraintEqualToAnchor:errorSectionHeaderView.bottomAnchor constant:EAPMDemoUISectionContentSpacing],
        [errorButtonStackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-EAPMDemoNetworkAnalysisContentBottomPadding],
        [errorButtonStackView.heightAnchor constraintEqualToConstant:EAPMDemoUISecondaryActionHeight],
    ]];
}

- (void)installDismissKeyboardGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundTapped)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)handleBackgroundTapped {
    [self.view endEditing:YES];
}

- (EAPMDemoSecondaryActionButton *)createErrorButtonWithTitle:(NSString *)title action:(SEL)action {
    EAPMDemoSecondaryActionButton *button = [EAPMDemoSecondaryActionButton buttonWithType:UIButtonTypeSystem];
    [button configureWithTitle:title];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)handleBackButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSendButtonTapped {
    [self.view endEditing:YES];
    NSString *normalizedURLString = [self normalizedURLString:self.urlTextField.text];
    if (normalizedURLString.length == 0) {
        normalizedURLString = EAPMDemoNetworkAnalysisDefaultURLString;
    }
    [self triggerRequestWithURLString:normalizedURLString];
}

- (void)handleTransportErrorButtonTapped {
    [self.view endEditing:YES];
    [self triggerRequestWithURLString:EAPMDemoNetworkAnalysisTransportErrorURLString];
}

- (void)handleHTTPErrorButtonTapped {
    [self.view endEditing:YES];
    [self triggerRequestWithURLString:EAPMDemoNetworkAnalysisHTTPErrorURLString];
}

- (nullable NSString *)normalizedURLString:(nullable NSString *)urlString {
    NSString *trimmedURLString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedURLString.length > 0 ? trimmedURLString : nil;
}

- (nullable NSURL *)validatedURLFromString:(NSString *)urlString {
    NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
    NSString *scheme = components.scheme.lowercaseString;
    BOOL isHTTPScheme = [scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"];
    if (components.URL == nil || !isHTTPScheme || components.host.length == 0) {
        return nil;
    }
    return components.URL;
}

- (void)triggerRequestWithURLString:(NSString *)urlString {
    if (self.requestInProgress) {
        return;
    }

    NSURL *url = [self validatedURLFromString:urlString];
    if (url == nil) {
        [self presentAlertWithTitle:@"提示" message:@"请输入有效的完整 HTTP(S) URL"];
        return;
    }

    self.requestInProgress = YES;
    [self updateInteractiveViewsEnabled:NO];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 15.0;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    configuration.timeoutIntervalForRequest = 15.0;
    configuration.timeoutIntervalForResource = 20.0;

    __weak typeof(self) weakSelf = self;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            [session finishTasksAndInvalidate];
            return;
        }

        NSHTTPURLResponse *httpResponse = [response isKindOfClass:[NSHTTPURLResponse class]] ? (NSHTTPURLResponse *)response : nil;
        BOOL requestSucceeded = (error == nil && httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299);
        NSString *statusCodeText = httpResponse ? [NSString stringWithFormat:@"%ld", (long)httpResponse.statusCode] : @"";
        NSAttributedString *message = [strongSelf resultMessageWithURLString:url.absoluteString
                                                            requestSucceeded:requestSucceeded
                                                              statusCodeText:statusCodeText];

        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.requestInProgress = NO;
            [strongSelf updateInteractiveViewsEnabled:YES];
            [strongSelf presentResultAlertWithMessage:message];
        });

        [session finishTasksAndInvalidate];
    }];
    [task resume];
}

- (void)updateInteractiveViewsEnabled:(BOOL)enabled {
    self.urlTextField.enabled = enabled;
    self.sendButton.enabled = enabled;
    self.transportErrorButton.enabled = enabled;
    self.httpErrorButton.enabled = enabled;
    [self.sendButton setTitle:(enabled ? @"发送请求" : @"请求中...") forState:UIControlStateNormal];

    CGFloat alpha = enabled ? 1.0 : 0.55;
    self.sendButton.alpha = alpha;
    self.transportErrorButton.alpha = alpha;
    self.httpErrorButton.alpha = alpha;
}

- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message {
    [EAPMDemoAlertPresenter presentAlertFrom:self
                                       title:title
                                     message:message
                            messageAlignment:EAPMDemoAlertMessageAlignmentLeft
                                     actions:@[
        [EAPMDemoAlertAction actionWithTitle:@"知道了"
                                       style:EAPMDemoAlertActionStylePrimary
                                         handler:nil],
    ]];
}

- (NSAttributedString *)resultMessageWithURLString:(NSString *)urlString
                                  requestSucceeded:(BOOL)requestSucceeded
                                    statusCodeText:(NSString *)statusCodeText {
    UIFont *bodyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15.0] ?: [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
    UIFont *symbolFont = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
    UIColor *labelColor = EAPMDemoNetworkAnalysisHexColor(0x5B6472, 1.0);
    UIColor *successColor = EAPMDemoNetworkAnalysisHexColor(0x24B36B, 1.0);
    UIColor *failureColor = EAPMDemoNetworkAnalysisHexColor(0xF04438, 1.0);
    NSString *statusSymbol = requestSucceeded ? @"✓" : @"✕";
    NSString *statusText = requestSucceeded ? @"Success" : @"Failure";
    UIColor *statusColor = requestSucceeded ? successColor : failureColor;

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.minimumLineHeight = 24.0;
    paragraphStyle.maximumLineHeight = 24.0;

    NSDictionary<NSAttributedStringKey, id> *bodyAttributes = @{
        NSFontAttributeName: bodyFont,
        NSForegroundColorAttributeName: labelColor,
        NSParagraphStyleAttributeName: paragraphStyle,
    };
    NSDictionary<NSAttributedStringKey, id> *symbolAttributes = @{
        NSFontAttributeName: symbolFont,
        NSForegroundColorAttributeName: statusColor,
        NSParagraphStyleAttributeName: paragraphStyle,
    };
    NSDictionary<NSAttributedStringKey, id> *statusAttributes = @{
        NSFontAttributeName: bodyFont,
        NSForegroundColorAttributeName: statusColor,
        NSParagraphStyleAttributeName: paragraphStyle,
    };

    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] init];
    [message appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"URL: %@\n", urlString] attributes:bodyAttributes]];
    [message appendAttributedString:[[NSAttributedString alloc] initWithString:@"Result: " attributes:bodyAttributes]];
    [message appendAttributedString:[[NSAttributedString alloc] initWithString:statusSymbol attributes:symbolAttributes]];
    [message appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@\n", statusText] attributes:statusAttributes]];
    [message appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Status Code: %@\n\n", statusCodeText] attributes:bodyAttributes]];
    [message appendAttributedString:[[NSAttributedString alloc] initWithString:@"请切换至后台触发上报，稍后可在 EMAS 控制台查看。" attributes:bodyAttributes]];
    return message;
}

- (void)presentResultAlertWithMessage:(NSAttributedString *)message {
    [EAPMDemoAlertPresenter presentAlertFrom:self
                                       title:@"网络请求"
                           attributedMessage:message
                                     actions:@[
        [EAPMDemoAlertAction actionWithTitle:@"知道了"
                                       style:EAPMDemoAlertActionStylePrimary
                                         handler:nil],
    ]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.urlTextField) {
        [self handleSendButtonTapped];
        return NO;
    }
    return YES;
}

@end
