//
//  ExampleViewController.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/19.
//

#import "ExampleViewController.h"
#import "PlaceHolderTextView.h"
#import "GeneralScenario.h"
#import "HTTPSSimpleScenario.h"
#import "HTTPSWithSNIScenario.h"
#import "AFNHttpsScenario.h"
#import "AFNHttpsWithSNIScenario.h"
#import "httpdns_ios_demo-Swift.h"
#import "AVPlayerScenario.h"
#import "CustomLineSpacingLabel.h"
#import "HTTPDNSDemoLoading.h"
#import "SDWebImageScenario.h"

@interface ExampleViewController ()

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *httpsScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *httpsWithSNIScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *generalScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *AFNetworkingScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *AFNetwrokingWithSNIScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *AlamofireScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *AlamofireWithSNIScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *AVPlayerScenario;

@property (weak, nonatomic) IBOutlet CustomLineSpacingLabel *SDWebImageScenario;

@property (weak, nonatomic) IBOutlet PlaceHolderTextView *resultTextView;

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

- (IBAction)httpsSimpleScenario:(id)sender {
    [self changeSelectedState:self.httpsScenario];

    [self showLoading];
    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    [[HTTPSSimpleScenario new] httpDnsQueryWithURL:originalUrl completionHandler:^(NSString *message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = message;
            [self stopLoading];
        });
    }];
}

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

- (IBAction)generalScenario:(id)sender {
    [self changeSelectedState:self.generalScenario];

    [self showLoading];
    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    originalUrl = [originalUrl stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
    [GeneralScenario httpDnsQueryWithURL:originalUrl completionHandler:^(NSString *message) {
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

- (void)changeSelectedState:(UILabel *)label {
    [self setupLayerFor:self.httpsScenario isSelected:NO];
    [self setupLayerFor:self.httpsWithSNIScenario isSelected:NO];
    [self setupLayerFor:self.generalScenario isSelected:NO];
    [self setupLayerFor:self.AFNetworkingScenario isSelected:NO];
    [self setupLayerFor:self.AFNetwrokingWithSNIScenario isSelected:NO];
    [self setupLayerFor:self.AlamofireScenario isSelected:NO];
    [self setupLayerFor:self.AlamofireWithSNIScenario isSelected:NO];
    [self setupLayerFor:self.AVPlayerScenario isSelected:NO];
    [self setupLayerFor:self.SDWebImageScenario isSelected:NO];

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

@end
