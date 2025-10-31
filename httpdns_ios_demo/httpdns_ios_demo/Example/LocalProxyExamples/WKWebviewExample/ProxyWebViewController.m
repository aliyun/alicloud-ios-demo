#import "ProxyWebViewController.h"
#import <EMASLocalProxy/EMASLocalHttpProxy.h>
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

@interface ProxyWebViewController ()
@property (nonatomic, strong) NSURL *targetURL;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ProxyWebViewController

#pragma mark - Initialization

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        _targetURL = url;
        self.title = @"HTTPDNS本地代理测试";
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置背景色
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }

    if (!self.webView) {
        [self createWebView];
    }

    // 设置约束
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // 水平方向约束
    [constraints addObject:[self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor]];
    [constraints addObject:[self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]];

    // 垂直方向约束
    [constraints addObject:[self.webView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor]];
    [constraints addObject:[self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]];

    [NSLayoutConstraint activateConstraints:constraints];

    // 添加关闭按钮
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
        initWithTitle:@"关闭"
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(closeButtonTapped)];

    self.navigationItem.leftBarButtonItem = closeButton;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // 在视图显示后加载URL
    if (self.targetURL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.targetURL];
        [self.webView loadRequest:request];
    }
}

#pragma mark - Private Methods

- (void)createWebView {
    // 创建 WKWebViewConfiguration
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];

    // 配置DNS解析器
    [EMASLocalHttpProxy setDNSResolverBlock:^NSArray<NSString *> * _Nullable(NSString * _Nonnull hostname) {
        return [self resolveHostnameWithHTTPDNS:hostname];
    }];

    [EMASLocalHttpProxy setLogLevel:EMASLocalHttpProxyLogLevelDebug];

    // 配置WebView代理
    if ([EMASLocalHttpProxy isProxyReady]) {
        BOOL proxyConfigured = [EMASLocalHttpProxy installIntoWebViewConfiguration:config];
        if (proxyConfigured) {
            NSLog(@"WKWebViewProxyScenario: Proxy configuration applied successfully");
        } else {
            NSLog(@"WKWebViewProxyScenario: Using system network (proxy unavailable)");
        }
    } else {
        NSLog(@"WKWebViewProxyScenario: Proxy haven't been ready.");
    }

    // 创建WKWebView
    CGRect bounds = self.view.bounds;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:bounds configuration:config];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView = webView;

    // 添加WebView到视图层级
    [self.view addSubview:webView];
}

- (void)closeButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Public Methods

- (NSArray<NSString *> *)resolveHostnameWithHTTPDNS:(NSString *)hostname {
    HttpDnsService *httpdns = [HttpDnsService sharedInstance];
    HttpdnsResult* result = [httpdns resolveHostSyncNonBlocking:hostname byIpType:HttpdnsQueryIPTypeAuto];

    if (result && (result.hasIpv4Address || result.hasIpv6Address)) {
        NSMutableArray<NSString *> *allIPs = [NSMutableArray array];
        if (result.hasIpv4Address) {
            [allIPs addObjectsFromArray:result.ips];
        }
        if (result.hasIpv6Address) {
            [allIPs addObjectsFromArray:result.ipv6s];
        }
        NSLog(@"DNS resolved %@ to IPs: %@", hostname, allIPs);
        return allIPs;
    }

    NSLog(@"DNS resolution failed for domain: %@", hostname);
    return nil;
}

@end 
