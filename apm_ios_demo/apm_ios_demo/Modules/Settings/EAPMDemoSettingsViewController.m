#import "EAPMDemoSettingsViewController.h"

#import "EAPMDemoConfigStore.h"
#import "../Shared/EAPMDemoUIComponents.h"
#import "../Shared/EAPMDemoUIStyleGuide.h"
#import <AlicloudApmCore/AlicloudApmCore.h>

@interface EAPMDemoSettingsViewController () <UITextFieldDelegate>

@property (nonatomic, strong) EAPMDemoSecondaryPageHeaderView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) EAPMDemoInputFieldView *userIdInputView;
@property (nonatomic, strong) EAPMDemoInputFieldView *userNickInputView;
@property (nonatomic, strong) EAPMDemoInputFieldView *utdidInputView;

@end

@implementation EAPMDemoSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"";
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = UIColor.whiteColor;

    [self buildViews];
    [self reloadValues];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)buildViews {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBlank)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];

    __weak typeof(self) weakSelf = self;
    self.headerView = [[EAPMDemoSecondaryPageHeaderView alloc] initWithTitle:@"设置" backHandler:^{
        [weakSelf handleBackButtonTapped];
    }];
    [self.view addSubview:self.headerView];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];

    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.contentView];

    self.userIdInputView = [[EAPMDemoInputFieldView alloc] initWithTitle:@"UserID" placeholder:@"请输入 UserID" editable:YES];
    self.userNickInputView = [[EAPMDemoInputFieldView alloc] initWithTitle:@"用户昵称" placeholder:@"请输入用户昵称" editable:YES];
    self.utdidInputView = [[EAPMDemoInputFieldView alloc] initWithTitle:@"UTDID" placeholder:@"" editable:NO];

    for (EAPMDemoInputFieldView *inputView in @[self.userIdInputView, self.userNickInputView, self.utdidInputView]) {
        [self.contentView addSubview:inputView];
    }

    self.userIdInputView.textField.delegate = self;
    self.userNickInputView.textField.delegate = self;
    self.userNickInputView.textField.returnKeyType = UIReturnKeyDone;

    EAPMDemoPrimaryButton *saveButton = [EAPMDemoPrimaryButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保存设置" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(handleSaveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:saveButton];

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

        [self.userIdInputView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [self.userIdInputView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
        [self.userIdInputView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:EAPMDemoUIContentTopSpacing],

        [self.userNickInputView.leadingAnchor constraintEqualToAnchor:self.userIdInputView.leadingAnchor],
        [self.userNickInputView.trailingAnchor constraintEqualToAnchor:self.userIdInputView.trailingAnchor],
        [self.userNickInputView.topAnchor constraintEqualToAnchor:self.userIdInputView.bottomAnchor constant:12.0],

        [self.utdidInputView.leadingAnchor constraintEqualToAnchor:self.userIdInputView.leadingAnchor],
        [self.utdidInputView.trailingAnchor constraintEqualToAnchor:self.userIdInputView.trailingAnchor],
        [self.utdidInputView.topAnchor constraintEqualToAnchor:self.userNickInputView.bottomAnchor constant:12.0],

        [saveButton.leadingAnchor constraintEqualToAnchor:self.userIdInputView.leadingAnchor],
        [saveButton.trailingAnchor constraintEqualToAnchor:self.userIdInputView.trailingAnchor],
        [saveButton.topAnchor constraintEqualToAnchor:self.utdidInputView.bottomAnchor constant:20.0],
        [saveButton.heightAnchor constraintEqualToConstant:EAPMDemoUIPrimaryButtonHeight],
        [saveButton.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-EAPMDemoUIContentBottomPadding],
    ]];
}

- (void)reloadValues {
    self.userIdInputView.textField.text = [EAPMDemoConfigStore storedUserId] ?: @"";
    self.userNickInputView.textField.text = [EAPMDemoConfigStore storedUserNick] ?: @"";

    NSString *utdid = [EAPMApm utdid];
    self.utdidInputView.textField.text = utdid.length > 0 ? utdid : @"获取失败";
}

- (void)handleTapBlank {
    [self.view endEditing:YES];
}

- (void)handleBackButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSaveButtonTapped {
    [self.view endEditing:YES];
    [EAPMDemoConfigStore saveUserId:self.userIdInputView.textField.text userNick:self.userNickInputView.textField.text];
    [EAPMDemoToastPresenter showToastInViewController:self message:@"设置已保存"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userIdInputView.textField) {
        [self.userNickInputView.textField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
