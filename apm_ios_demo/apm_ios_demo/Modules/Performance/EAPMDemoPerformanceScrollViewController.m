#import "EAPMDemoPerformanceScrollViewController.h"
#import "../Shared/EAPMDemoUIStyleGuide.h"

static UIColor *EAPMDemoPerformanceHexColor(NSUInteger hexValue, CGFloat alpha) {
    return [UIColor colorWithRed:((hexValue >> 16) & 0xFF) / 255.0
                           green:((hexValue >> 8) & 0xFF) / 255.0
                            blue:(hexValue & 0xFF) / 255.0
                           alpha:alpha];
}

@interface EAPMDemoPerformanceScrollViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation EAPMDemoPerformanceScrollViewController

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
    self.headerView = [[UIView alloc] init];
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.headerView];

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
    backButton.tintColor = EAPMDemoPerformanceHexColor(0x1F2024, 1.0);
    [backButton addTarget:self action:@selector(handleBackButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:backButton];

    UILabel *pageTitleLabel = [[UILabel alloc] init];
    pageTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    pageTitleLabel.attributedText = EAPMDemoPageTitleAttributedString(@"页面分析", EAPMDemoPerformanceHexColor(0x4B4D52, 1.0));
    [self.headerView addSubview:pageTitleLabel];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];

    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.contentView];

    UIView *bannerView = [[UIView alloc] init];
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    EAPMDemoApplyTipCardStyle(bannerView, EAPMDemoPerformanceHexColor(0xEEF3FF, 1.0));
    [self.contentView addSubview:bannerView];

    UILabel *bannerLabel = [[UILabel alloc] init];
    bannerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    bannerLabel.numberOfLines = 0;
    bannerLabel.text = @"请滑动页面。页面分析数据在App退至后台时统一上报，稍后可在 EMAS 控制台查看。";
    bannerLabel.attributedText = EAPMDemoInfoAttributedString(bannerLabel.text, EAPMDemoPerformanceHexColor(0x7A8FB8, 1.0));
    [bannerView addSubview:bannerLabel];

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emas_logo"]];
    logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:logoImageView];

    UILabel *brandLabel = [[UILabel alloc] init];
    brandLabel.translatesAutoresizingMaskIntoConstraints = NO;
    UIFont *brandFont = [UIFont fontWithName:@"PingFangSC-Medium" size:22.0] ?: [UIFont systemFontOfSize:22.0 weight:UIFontWeightMedium];
    brandLabel.attributedText = [[NSAttributedString alloc] initWithString:@"阿里云EMAS" attributes:@{
        NSFontAttributeName: brandFont,
        NSForegroundColorAttributeName: EAPMDemoPerformanceHexColor(0x1F2024, 1.0),
        NSKernAttributeName: @(1.6),
    }];
    [self.contentView addSubview:brandLabel];

    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.translatesAutoresizingMaskIntoConstraints = NO;
    introLabel.numberOfLines = 0;
    introLabel.attributedText = EAPMDemoBodyAttributedString(@"EMAS（Enterprise Mobile Application Service）是阿里云面向移动研发领域，提供一站式移动应用研发管理服务。覆盖开发、测试、运维、运营四个环节，帮助企业快速搭建稳定高质量的移动应用。",
                                                             EAPMDemoPerformanceHexColor(0x5A616E, 1.0));
    [self.contentView addSubview:introLabel];

    UIView *previousView = introLabel;
    NSArray<NSDictionary<NSString *, NSString *> *> *sections = @[
        @{
            @"title": @"APM 性能监控",
            @"body": @"EMAS APM（Application Performance Management）是面向移动端的性能监控产品，提供崩溃分析、性能分析、远程日志等核心能力，帮助开发者快速定位和解决线上问题。"
        },
        @{
            @"title": @"崩溃分析",
            @"body": @"支持 Java Crash、Native Crash、ANR 等多种崩溃类型的自动采集与分析。提供完整的崩溃堆栈信息，支持符号表自动反解，帮助开发者快速定位崩溃根因。"
        },
        @{
            @"title": @"性能分析",
            @"body": @"提供启动速度、页面加载、帧率监控、卡顿检测等全方位性能数据采集能力。支持 P50/P90/P99 分位数统计，帮助开发者系统性地优化应用性能。"
        },
        @{
            @"title": @"网络监控",
            @"body": @"自动采集 HTTP/HTTPS 请求的全链路耗时数据，包括 DNS 解析、TCP 连接、TLS 握手、首字节时间等各阶段耗时。支持慢请求分析和错误请求统计。"
        },
        @{
            @"title": @"内存分析",
            @"body": @"提供内存泄漏检测、大内存分配监控、OOM 崩溃分析等能力。支持 Activity/Fragment 泄漏检测，帮助开发者及时发现和修复内存问题。"
        },
        @{
            @"title": @"远程日志",
            @"body": @"支持远程日志拉取、日志级别动态调整、日志检索等能力。开发者可以针对特定设备或用户下发日志拉取任务，无需用户配合即可获取详细的运行日志。"
        },
        @{
            @"title": @"多端支持",
            @"body": @"EMAS APM 支持 Android、iOS、HarmonyOS NEXT、H5、Flutter 等多个平台，提供统一的监控体验和数据分析能力。一次接入，全平台覆盖。"
        }
    ];

    NSMutableArray<NSLayoutConstraint *> *sectionConstraints = [NSMutableArray array];
    for (NSDictionary<NSString *, NSString *> *section in sections) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.text = section[@"title"];
        titleLabel.font = EAPMDemoUIFontMedium(18.0);
        titleLabel.textColor = EAPMDemoPerformanceHexColor(0x1F2024, 1.0);
        [self.contentView addSubview:titleLabel];

        UILabel *bodyLabel = [[UILabel alloc] init];
        bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
        bodyLabel.numberOfLines = 0;
        bodyLabel.attributedText = EAPMDemoBodyAttributedString(section[@"body"], EAPMDemoPerformanceHexColor(0x5A616E, 1.0));
        [self.contentView addSubview:bodyLabel];

        [sectionConstraints addObjectsFromArray:@[
            [titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
            [titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
            [titleLabel.topAnchor constraintEqualToAnchor:previousView.bottomAnchor constant:EAPMDemoUISectionTopSpacing],

            [bodyLabel.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
            [bodyLabel.trailingAnchor constraintEqualToAnchor:titleLabel.trailingAnchor],
            [bodyLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:8.0],
        ]];
        previousView = bodyLabel;
    }

    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [self.headerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.headerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.headerView.topAnchor constraintEqualToAnchor:safeArea.topAnchor],

        [backButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [backButton.topAnchor constraintEqualToAnchor:self.headerView.topAnchor constant:EAPMDemoUIHeaderTopPadding],
        [backButton.widthAnchor constraintEqualToConstant:20.0],
        [backButton.heightAnchor constraintEqualToConstant:20.0],

        [pageTitleLabel.leadingAnchor constraintEqualToAnchor:backButton.trailingAnchor constant:EAPMDemoUIHeaderTitleSpacing],
        [pageTitleLabel.centerYAnchor constraintEqualToAnchor:backButton.centerYAnchor],

        [self.headerView.bottomAnchor constraintEqualToAnchor:pageTitleLabel.bottomAnchor constant:EAPMDemoUIHeaderBottomPadding],

        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor],
        [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor],

        [bannerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [bannerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
        [bannerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:EAPMDemoUIContentTopSpacing],

        [bannerLabel.leadingAnchor constraintEqualToAnchor:bannerView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [bannerLabel.trailingAnchor constraintEqualToAnchor:bannerView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
        [bannerLabel.topAnchor constraintEqualToAnchor:bannerView.topAnchor constant:EAPMDemoUITipCardVerticalInset],
        [bannerLabel.bottomAnchor constraintEqualToAnchor:bannerView.bottomAnchor constant:-EAPMDemoUITipCardVerticalInset],

        [logoImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [logoImageView.topAnchor constraintEqualToAnchor:bannerView.bottomAnchor constant:EAPMDemoUISectionTopSpacing],
        [logoImageView.widthAnchor constraintEqualToConstant:34.0],
        [logoImageView.heightAnchor constraintEqualToConstant:26.0],

        [brandLabel.leadingAnchor constraintEqualToAnchor:logoImageView.trailingAnchor constant:10.0],
        [brandLabel.centerYAnchor constraintEqualToAnchor:logoImageView.centerYAnchor],
        [brandLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],

        [introLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:EAPMDemoUIHorizontalInset],
        [introLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-EAPMDemoUIHorizontalInset],
        [introLabel.topAnchor constraintEqualToAnchor:logoImageView.bottomAnchor constant:EAPMDemoUISectionContentSpacing],

        [previousView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-EAPMDemoUIContentBottomPadding],
    ]];
    [NSLayoutConstraint activateConstraints:sectionConstraints];

    [bannerLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [bannerLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)handleBackButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
