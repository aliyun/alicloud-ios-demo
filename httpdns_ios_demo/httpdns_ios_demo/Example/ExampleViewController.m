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

@interface ExampleViewController ()

@property (weak, nonatomic) IBOutlet PlaceHolderTextView *resultTextView;

@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.resultTextView.placeholder = @"请选择具体案例";
    self.resultTextView.textContainerInset = UIEdgeInsetsMake(12, 20, 12, 20);
}

- (void)cleanTextView {
    [self.resultTextView setContentOffset:CGPointZero animated:NO];
    self.resultTextView.text = nil;
}

#pragma mark - action

- (IBAction)httpsSimpleScenario:(id)sender {
    [self cleanTextView];

    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    [[HTTPSSimpleScenario new] httpDnsQueryWithURL:originalUrl completionHandler:^(NSString *message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = message;
        });
    }];
}

- (IBAction)httpsWithSNIScenario:(id)sender {
    [self cleanTextView];

    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    [HTTPSWithSNIScenario httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = message;
        });
    }];
}

- (IBAction)generalScenario:(id)sender {
    [self cleanTextView];

    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    [GeneralScenario httpDnsQueryWithURL:originalUrl completionHandler:^(NSString *message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = message;
        });
    }];
}

- (IBAction)AFNetworkingScenario:(id)sender {
    [self cleanTextView];

    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    [AFNHttpsScenario httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = message;
        });
    }];
}

- (IBAction)AFNetworkingWithSNIScenario:(id)sender {
    [self cleanTextView];

    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    [AFNHttpsWithSNIScenario httpDnsQueryWithURL:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = message;
        });
    }];
}

- (IBAction)AlamofireScenario:(id)sender {
    [self cleanTextView];

    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    [AlamofireHttpsScenario httpDnsQueryWithURLWithOriginalUrl:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = message;
        });
    }];
}

- (IBAction)AlamofireWithSNIScenario:(id)sender {
    [self cleanTextView];

    NSString *originalUrl = [HTTPDNSDemoUtils exampleTextUrlString];
    [AlamofireHttpsWithSNIScenario httpDnsQueryWithURLWithOriginalUrl:originalUrl completionHandler:^(NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultTextView.text = message;
        });
    }];
}

- (IBAction)AVPlayerScenario:(id)sender {
    NSString *originalUrl = [HTTPDNSDemoUtils exampleVideoUrlString];
    [AVPlayerScenario httpDnsQueryWithURL:originalUrl];
}

@end
