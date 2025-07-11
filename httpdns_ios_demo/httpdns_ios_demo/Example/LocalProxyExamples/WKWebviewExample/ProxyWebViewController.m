#import "ProxyWebViewController.h"
#import "HttpdnsLocalHttpProxy.h"
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

    // 配置WebView代理
    BOOL proxyConfigured = [HttpdnsLocalHttpProxy installIntoWebViewConfiguration:config];
    if (proxyConfigured) {
        NSLog(@"WKWebViewProxyScenario: Proxy configuration applied successfully");
    } else {
        NSLog(@"WKWebViewProxyScenario: Using system network (proxy unavailable)");
    }

    // 配置DNS解析器
    [HttpdnsLocalHttpProxy setDNSResolverBlock:^NSString *(NSString *hostname) {
        return [self resolveHostnameWithHTTPDNS:hostname];
    }];

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

+ (void)presentWithURL:(NSURL *)url {

}

- (NSString *)resolveHostnameWithHTTPDNS:(NSString *)hostname {
    // 获取HTTPDNS服务实例
    HttpDnsService *httpdns = [HttpDnsService sharedInstance];
    if (!httpdns) {
        return hostname;
    }

    // 使用HTTPDNS解析域名
    HttpdnsResult *result = [httpdns resolveHostSync:hostname byIpType:HttpdnsQueryIPTypeAuto];

    if (result) {
        NSString *resolvedIP = nil;

        // 使用IPv4地址
        if ([result hasIpv4Address]) {
            resolvedIP = [result firstIpv4Address];
            NSLog(@"WKWebViewProxyScenario: HTTPDNS IPv4 resolved: %@ -> %@", hostname, resolvedIP);
        } else if ([result hasIpv6Address]) {
            // 如果没有IPv4地址，使用IPv6地址
            resolvedIP = [result firstIpv6Address];
            NSLog(@"WKWebViewProxyScenario: HTTPDNS IPv6 resolved: %@ -> %@", hostname, resolvedIP);
        }

        if (resolvedIP) {
            return resolvedIP;
        }
    }

    NSLog(@"WKWebViewProxyScenario: HTTPDNS resolution failed, using original hostname: %@", hostname);
    return hostname;
}

@end 
