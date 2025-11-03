//
//  ExampleViewController.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/19.
//

#import "ExampleViewController.h"
#import "PlaceHolderTextView.h"
#import "HTTPSWithSNIScenario.h"
#import "AFNHttpsScenario.h"
#import "AFNHttpsWithSNIScenario.h"
#import "httpdns_ios_demo-Swift.h"
#import "AVPlayerScenario.h"
#import "CustomLineSpacingLabel.h"
#import "HTTPDNSDemoLoading.h"
#import "SDWebImageScenario.h"
#import "ProxyWebViewController.h"
#import "EmascurlScenario.h"

@interface ExampleViewController ()

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *httpsWithSNIScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *AFNetworkingScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *AFNetwrokingWithSNIScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *AlamofireScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *AlamofireWithSNIScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *AVPlayerScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *SDWebImageScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *WKWebViewProxyScenario;

@property (weak, nonatomic) IBOutlet PlaceHolderTextView *resultTextView;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *emasCurlScenario;

@property(nonatomic, strong)HTTPDNSDemoLoading *loading;

@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.resultTextView.placeholder = @"请选择具体案例";
    self.resultTextView.textContainerInset = UIEdgeInsetsMake(12, 20, 12, 20);

    self.loading = [[HTTPDNSDemoLoading alloc] initWithFrame:self.resultTextView.bounds];
    self.loading.hidden = YES;
    [self.resultTextView addSubview:self.loading];
}

- (void)showLoading {
    [self.loading startLoading];
}

- (void)stopLoading {
    [self.loading stopLoading];
}

#pragma mark - action

- (IBAction)httpsWithSNIScenario:(id)sender {
    [self changeSelectedState:self.httpsWithSNIScenario];

    [self showLoading];
    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    [HTTPSWithSNIScenario httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = message;
            [self stopLoading];
        });
    }];
}

- (IBAction)AFNetworkingScenario:(id)sender {
    [self changeSelectedState:self.AFNetworkingScenario];

    [self showLoading];
    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    [AFNHttpsScenario httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = message;
            [self stopLoading];
        });
    }];
}

- (IBAction)AFNetworkingWithSNIScenario:(id)sender {
    [self changeSelectedState:self.AFNetwrokingWithSNIScenario];

    [self showLoading];
    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    [AFNHttpsWithSNIScenario httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = message;
            [self stopLoading];
        });
    }];
}

- (IBAction)AlamofireScenario:(id)sender {
    [self changeSelectedState:self.AlamofireScenario];

    [self showLoading];
    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    [AlamofireHttpsScenario httpDnsQueryWithURLWithOriginalUrl:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = message;
            [self stopLoading];
        });
    }];
}

- (IBAction)AlamofireWithSNIScenario:(id)sender {
    [self changeSelectedState:self.AlamofireWithSNIScenario];

    [self showLoading];
    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    [AlamofireHttpsWithSNIScenario httpDnsQueryWithURLWithOriginalUrl:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = message;
            [self stopLoading];
        });
    }];
}

- (IBAction)AVPlayerScenario:(id)sender {
    [self changeSelectedState:self.AVPlayerScenario];
    NSString *originalUrl = [HTTPDNSDemoUtils exampleVideoUrlString];
    [AVPlayerScenario httpDnsQueryWithURL:originalUrl];
}

- (IBAction)SDWebImageScenario:(id)sender {
    [self changeSelectedState:self.SDWebImageScenario];
    NSString *originalUrl = [HTTPDNSDemoUtils exampleImageUrlString];
    [SDWebImageScenario httpDnsQueryWithURL:originalUrl];
}

- (IBAction)WKWebViewProxyScenario:(id)sender {
    [self changeSelectedState:self.WKWebViewProxyScenario];

    [self showLoading];

    // 获取当前显示的视图控制器
    UIViewController *presentingVC = nil;

    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = (UIWindowScene *)[[[UIApplication sharedApplication] connectedScenes] anyObject];
        presentingVC = windowScene.windows.firstObject.rootViewController;
    } else {
        presentingVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    }

    while (presentingVC.presentedViewController) {
        presentingVC = presentingVC.presentedViewController;
    }

    NSURL *url = [NSURL URLWithString:@"https://m.taobao.com"];
    // 创建WebView控制器
    ProxyWebViewController *webViewController = [[ProxyWebViewController alloc] initWithURL:url];

    // 创建导航控制器
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;

    // 显示WebView
    [presentingVC presentViewController:navController animated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = @"已加载WebView页面";
            [self stopLoading];
        });
    }];
}

- (IBAction)EmasCurlScenario:(id)sender {
    [self changeSelectedState:self.emasCurlScenario];

    [self showLoading];
    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    [EmasCurlScenario httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = message;
            [self stopLoading];
        });
    }];
}

- (void)changeSelectedState:(UILabel *)label {
    // 清除下方展示区域的内容（传递当前选中的标签信息）
    [self clearResultTextViewForLabel:label];

    [self setupLayerFor:self.httpsWithSNIScenario isSelected:NO];
    [self setupLayerFor:self.AFNetworkingScenario isSelected:NO];
    [self setupLayerFor:self.AFNetwrokingWithSNIScenario isSelected:NO];
    [self setupLayerFor:self.AlamofireScenario isSelected:NO];
    [self setupLayerFor:self.AlamofireWithSNIScenario isSelected:NO];
    [self setupLayerFor:self.AVPlayerScenario isSelected:NO];
    [self setupLayerFor:self.SDWebImageScenario isSelected:NO];
    [self setupLayerFor:self.WKWebViewProxyScenario isSelected:NO];
    [self setupLayerFor:self.emasCurlScenario isSelected:NO];

    [self setupLayerFor:label isSelected:YES];
}

- (void)setupLayerFor:(UILabel *)label isSelected:(BOOL)isSelected {
    UIColor *color = [UIColor colorWithHexString:@"#424FF7"];
    if (isSelected == NO) {
        color = [UIColor colorWithHexString:@"#A7BCCE"];
    }
    label.layer.borderColor = color.CGColor;
    label.layer.borderWidth = 1;
    label.textColor = color;
}


- (void)clearResultTextViewForLabel:(UILabel *)label {
    // 清除展示区域的内容，恢复占位符文本
    self.resultTextView.text = @"";

    // 只有在非WKWebViewProxyScenario场景下才停止加载动画
    // 因为WKWebViewProxyScenario会在changeSelectedState后立即调用showLoading
    if (label != self.WKWebViewProxyScenario) {
        [self stopLoading];
    }
}

// 保留原方法供其他地方调用
- (void)clearResultTextView {
    [self clearResultTextViewForLabel:nil];
}

@end
