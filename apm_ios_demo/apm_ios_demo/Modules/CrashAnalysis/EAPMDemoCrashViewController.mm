#import "EAPMDemoCrashViewController.h"

#import "../Shared/EAPMDemoOverlayPresenter.h"
#import "../Shared/EAPMDemoUIComponents.h"
#import "../Shared/EAPMDemoUIStyleGuide.h"
#import <pthread.h>
#import <signal.h>
#import <stdlib.h>
#import <string.h>
#import <TargetConditionals.h>
#import <stdexcept>
#import <unistd.h>

static UIColor *EAPMDemoCrashHexColor(NSUInteger hexValue, CGFloat alpha) {
    return [UIColor colorWithRed:((hexValue >> 16) & 0xFF) / 255.0
                           green:((hexValue >> 8) & 0xFF) / 255.0
                           blue:(hexValue & 0xFF) / 255.0
                           alpha:alpha];
}

static NSMutableArray<NSValue *> *EAPMDemoOOMPointers(void) {
    static NSMutableArray<NSValue *> *pointers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pointers = [NSMutableArray array];
    });
    return pointers;
}

static const size_t EAPMDemoStackOverflowThreadStackSize = 128 * 1024;
static const size_t EAPMDemoStackOverflowGuardSize = 16 * 1024;
static const size_t EAPMDemoStackOverflowFrameSize = 16 * 1024;

__attribute__((noinline, optnone)) static NSUInteger EAPMDemoTriggerStackOverflow(NSUInteger depth) {
    volatile char stackFrame[EAPMDemoStackOverflowFrameSize];
    for (size_t index = 0; index < sizeof(stackFrame); index++) {
        stackFrame[index] = (char)((depth + index) & 0x7F);
    }

    return (NSUInteger)stackFrame[depth % sizeof(stackFrame)] + EAPMDemoTriggerStackOverflow(depth + 1);
}

static void *EAPMDemoTriggerStackOverflowThreadEntry(void *context) {
    (void)context;
    (void)EAPMDemoTriggerStackOverflow(1);
    return NULL;
}

static void EAPMDemoTriggerStackOverflowOnSmallStackThread(void) {
    pthread_attr_t attr;
    int attrInitResult = pthread_attr_init(&attr);
    if (attrInitResult != 0) {
        NSLog(@"Failed to init stack overflow thread attributes: %d", attrInitResult);
        (void)EAPMDemoTriggerStackOverflow(1);
        return;
    }

    size_t stackSize = EAPMDemoStackOverflowThreadStackSize;
    if (stackSize < PTHREAD_STACK_MIN) {
        stackSize = PTHREAD_STACK_MIN;
    }

    int stackSizeResult = pthread_attr_setstacksize(&attr, stackSize);
    int guardSizeResult = pthread_attr_setguardsize(&attr, EAPMDemoStackOverflowGuardSize);
    pthread_t thread;
    int createResult = 0;
    if (stackSizeResult == 0 && guardSizeResult == 0) {
        createResult = pthread_create(&thread, &attr, EAPMDemoTriggerStackOverflowThreadEntry, NULL);
    }

    pthread_attr_destroy(&attr);

    if (stackSizeResult != 0 || guardSizeResult != 0 || createResult != 0) {
        NSLog(@"Failed to create stack overflow thread. stack=%d guard=%d create=%d",
              stackSizeResult,
              guardSizeResult,
              createResult);
        (void)EAPMDemoTriggerStackOverflow(1);
        return;
    }

    pthread_detach(thread);
}

typedef NS_ENUM(NSInteger, EAPMDemoCrashTriggerType) {
    EAPMDemoCrashTriggerTypeNSException = 0,
    EAPMDemoCrashTriggerTypeCpp,
    EAPMDemoCrashTriggerTypeMach,
    EAPMDemoCrashTriggerTypeSignal,
    EAPMDemoCrashTriggerTypeHang,
    EAPMDemoCrashTriggerTypeOOM,
    EAPMDemoCrashTriggerTypeAsyncException,
    EAPMDemoCrashTriggerTypeDeadlock,
    EAPMDemoCrashTriggerTypeAbort,
    EAPMDemoCrashTriggerTypeStackOverflow,
};

@interface EAPMDemoCrashViewController ()

@property (nonatomic, strong) EAPMDemoSecondaryPageHeaderView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation EAPMDemoCrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"";
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = UIColor.whiteColor;

    [self buildViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)buildViews {
    __weak typeof(self) weakSelf = self;
    self.headerView = [[EAPMDemoSecondaryPageHeaderView alloc] initWithTitle:@"其它类型崩溃" backHandler:^{
        [weakSelf handleBackButtonTapped];
    }];
    [self.view addSubview:self.headerView];

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];

    _contentView = [[UIView alloc] init];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_contentView];

    EAPMDemoTipCardView *tipCardView = [[EAPMDemoTipCardView alloc] initWithBackgroundColor:EAPMDemoCrashHexColor(0xEEF3FF, 1.0)
                                                                                   textColor:EAPMDemoCrashHexColor(0x7A8FB8, 1.0)
                                                                                 borderColor:nil];
    [tipCardView configureWithText:@"更多崩溃和错误类型，点击按钮触发对应类型的异常。触发后请前往 EMAS 控制台查看崩溃详情和堆栈信息。"];
    [_contentView addSubview:tipCardView];

    EAPMDemoSectionHeaderView *sectionHeaderView = [[EAPMDemoSectionHeaderView alloc] init];
    sectionHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    [sectionHeaderView configureWithTitle:@"崩溃列表"];
    [_contentView addSubview:sectionHeaderView];

    NSArray<NSDictionary<NSString *, id> *> *items = @[
        @{@"title": @"NSException", @"type": @(EAPMDemoCrashTriggerTypeNSException)},
        @{@"title": @"C++ 异常", @"type": @(EAPMDemoCrashTriggerTypeCpp)},
        @{@"title": @"Mach 异常", @"type": @(EAPMDemoCrashTriggerTypeMach)},
        @{@"title": @"SIGNAL 崩溃", @"type": @(EAPMDemoCrashTriggerTypeSignal)},
        @{@"title": @"卡死", @"type": @(EAPMDemoCrashTriggerTypeHang)},
        @{@"title": @"OOM", @"type": @(EAPMDemoCrashTriggerTypeOOM)},
        @{@"title": @"AsyncException", @"type": @(EAPMDemoCrashTriggerTypeAsyncException)},
        @{@"title": @"Deadlock", @"type": @(EAPMDemoCrashTriggerTypeDeadlock)},
        @{@"title": @"Abort", @"type": @(EAPMDemoCrashTriggerTypeAbort)},
        @{@"title": @"Stack Overflow", @"type": @(EAPMDemoCrashTriggerTypeStackOverflow)},
    ];

    UIStackView *gridStackView = [[UIStackView alloc] init];
    gridStackView.translatesAutoresizingMaskIntoConstraints = NO;
    gridStackView.axis = UILayoutConstraintAxisVertical;
    gridStackView.spacing = 6.0;
    [_contentView addSubview:gridStackView];

    for (NSInteger index = 0; index < items.count; index += 2) {
        UIStackView *rowStackView = [[UIStackView alloc] init];
        rowStackView.axis = UILayoutConstraintAxisHorizontal;
        rowStackView.alignment = UIStackViewAlignmentFill;
        rowStackView.distribution = UIStackViewDistributionFillEqually;
        rowStackView.spacing = 6.0;

        NSRange range = NSMakeRange(index, MIN(2, items.count - index));
        NSArray<NSDictionary<NSString *, id> *> *rowItems = [items subarrayWithRange:range];
        for (NSDictionary<NSString *, id> *item in rowItems) {
            UIButton *button = [self createCrashButtonWithTitle:item[@"title"] type:(EAPMDemoCrashTriggerType)[item[@"type"] integerValue]];
            [rowStackView addArrangedSubview:button];
        }

        if (rowItems.count == 1) {
            UIView *placeholderView = [[UIView alloc] init];
            [rowStackView addArrangedSubview:placeholderView];
        }

        [gridStackView addArrangedSubview:rowStackView];
        [rowStackView.heightAnchor constraintEqualToConstant:EAPMDemoUISecondaryActionHeight].active = YES;
    }

    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [self.headerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.headerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.headerView.topAnchor constraintEqualToAnchor:safeArea.topAnchor],

        [_scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [_scrollView.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [_scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [_contentView.leadingAnchor constraintEqualToAnchor:_scrollView.contentLayoutGuide.leadingAnchor],
        [_contentView.trailingAnchor constraintEqualToAnchor:_scrollView.contentLayoutGuide.trailingAnchor],
        [_contentView.topAnchor constraintEqualToAnchor:_scrollView.contentLayoutGuide.topAnchor],
        [_contentView.bottomAnchor constraintEqualToAnchor:_scrollView.contentLayoutGuide.bottomAnchor],
        [_contentView.widthAnchor constraintEqualToAnchor:_scrollView.frameLayoutGuide.widthAnchor],

        [tipCardView.leadingAnchor constraintEqualToAnchor:_contentView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [tipCardView.trailingAnchor constraintEqualToAnchor:_contentView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
        [tipCardView.topAnchor constraintEqualToAnchor:_contentView.topAnchor constant:EAPMDemoUIContentTopSpacing],

        [sectionHeaderView.leadingAnchor constraintEqualToAnchor:_contentView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [sectionHeaderView.trailingAnchor constraintEqualToAnchor:_contentView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
        [sectionHeaderView.topAnchor constraintEqualToAnchor:tipCardView.bottomAnchor constant:EAPMDemoUISectionTopSpacing],

        [gridStackView.leadingAnchor constraintEqualToAnchor:_contentView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [gridStackView.trailingAnchor constraintEqualToAnchor:_contentView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
        [gridStackView.topAnchor constraintEqualToAnchor:sectionHeaderView.bottomAnchor constant:EAPMDemoUISectionContentSpacing],
        [gridStackView.bottomAnchor constraintEqualToAnchor:_contentView.bottomAnchor constant:-EAPMDemoUIContentBottomPadding],
    ]];
}

- (UIButton *)createCrashButtonWithTitle:(NSString *)title type:(EAPMDemoCrashTriggerType)type {
    EAPMDemoSecondaryActionButton *button = [EAPMDemoSecondaryActionButton buttonWithType:UIButtonTypeSystem];
    button.tag = type;
    [button configureWithTitle:title];
    [button addTarget:self action:@selector(handleTriggerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)handleBackButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleTriggerButtonTapped:(UIButton *)sender {
    switch ((EAPMDemoCrashTriggerType)sender.tag) {
        case EAPMDemoCrashTriggerTypeNSException: {
            [self presentCrashConfirmAlertWithTitle:@"NSException" confirmAction:^{
                @throw [NSException exceptionWithName:@"DemoNSException"
                                               reason:@"Trigger NSException in demo page."
                                             userInfo:nil];
            }];
            break;
        }
        case EAPMDemoCrashTriggerTypeCpp: {
            [self presentCrashConfirmAlertWithTitle:@"C++ 异常" confirmAction:^{
                throw std::runtime_error("Trigger C++ crash in demo page.");
            }];
            break;
        }
        case EAPMDemoCrashTriggerTypeMach: {
            [self presentCrashConfirmAlertWithTitle:@"Mach 异常" confirmAction:^{
                __builtin_trap();
            }];
            break;
        }
        case EAPMDemoCrashTriggerTypeSignal: {
            [self presentCrashConfirmAlertWithTitle:@"SIGNAL 崩溃" confirmAction:^{
                raise(SIGSEGV);
            }];
            break;
        }
        case EAPMDemoCrashTriggerTypeHang: {
            [self presentCrashConfirmAlertWithTitle:@"卡死" confirmAction:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSThread sleepForTimeInterval:60.0];
                });
            }];
            break;
        }
        case EAPMDemoCrashTriggerTypeOOM: {
            [[self class] presentOOMAlertFromViewController:self];
            break;
        }
        case EAPMDemoCrashTriggerTypeAsyncException: {
            [self presentCrashConfirmAlertWithTitle:@"AsyncException" confirmAction:^{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @throw [NSException exceptionWithName:@"DemoAsyncException"
                                                   reason:@"Trigger async exception in demo page."
                                                 userInfo:nil];
                });
            }];
            break;
        }
        case EAPMDemoCrashTriggerTypeDeadlock: {
            [self presentCrashConfirmAlertWithTitle:@"Deadlock" confirmAction:^{
                dispatch_queue_t serialQueue = dispatch_queue_create("com.aliyun.emas.demo.deadlock", DISPATCH_QUEUE_SERIAL);
                dispatch_async(serialQueue, ^{
                    NSLog(@"Task 1");
                    dispatch_barrier_sync(serialQueue, ^{
                        NSLog(@"Barrier Task");
                    });
                    NSLog(@"This will never be printed because of the deadlock");
                });
                NSLog(@"Code after dispatch_async");
            }];
            break;
        }
        case EAPMDemoCrashTriggerTypeAbort: {
            [self presentCrashConfirmAlertWithTitle:@"Abort" confirmAction:^{
                abort();
            }];
            break;
        }
        case EAPMDemoCrashTriggerTypeStackOverflow: {
            [self presentCrashConfirmAlertWithTitle:@"Stack Overflow" confirmAction:^{
                EAPMDemoTriggerStackOverflowOnSmallStackThread();
            }];
            break;
        }
    }
}

+ (void)presentOOMAlertFromViewController:(UIViewController *)viewController {
    if (!viewController || viewController.presentedViewController) {
        return;
    }

    [EAPMDemoAlertPresenter presentAlertFrom:viewController
                                       title:@"OOM"
                                     message:@"即将触发「OOM」，App将闪退，重启App之后可在 EMAS 控制台看到崩溃信息。"
                                     actions:@[
        [EAPMDemoAlertAction actionWithTitle:@"取消"
                                       style:EAPMDemoAlertActionStyleSecondary
                                         handler:nil],
        [EAPMDemoAlertAction actionWithTitle:@"确定"
                                       style:EAPMDemoAlertActionStylePrimary
                                         handler:^{
            [self triggerOOM];
        }],
    ]];
}

+ (void)triggerOOM {
    NSMutableArray<NSValue *> *oomPointers = EAPMDemoOOMPointers();
    [oomPointers removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        const size_t chunkSize =
#if TARGET_OS_SIMULATOR
            64 * 1024 * 1024;
#else
            16 * 1024 * 1024;
#endif

        while (YES) {
            @autoreleasepool {
                void *chunk = malloc(chunkSize);
                if (!chunk) {
                    abort();
                }

                // Touch the full block so the allocator commits real resident memory.
                memset(chunk, 0xA5, chunkSize);
                [oomPointers addObject:[NSValue valueWithPointer:chunk]];
                usleep(20000);
            }
        }
    });
}

- (void)presentCrashConfirmAlertWithTitle:(NSString *)title confirmAction:(dispatch_block_t)confirmAction {
    NSString *message = [NSString stringWithFormat:@"即将触发「%@」，App将闪退，稍后可在 EMAS 控制台看到崩溃信息。", title];
    [self presentHomeStyleAlertWithTitle:title message:message confirmAction:confirmAction];
}

- (void)presentHomeStyleAlertWithTitle:(NSString *)title
                               message:(NSString *)message
                         confirmAction:(dispatch_block_t)confirmAction {
    if (self.presentedViewController) {
        return;
    }

    [EAPMDemoAlertPresenter presentAlertFrom:self
                                       title:title
                                     message:message
                                     actions:@[
        [EAPMDemoAlertAction actionWithTitle:@"取消"
                                       style:EAPMDemoAlertActionStyleSecondary
                                         handler:nil],
        [EAPMDemoAlertAction actionWithTitle:@"确定"
                                       style:EAPMDemoAlertActionStylePrimary
                                         handler:confirmAction],
    ]];
}

@end
