//
//  ExampleViewController.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/19.
//

#import "ExampleViewController.h"
#import "PlaceHolderTextView.h"

@interface ExampleViewController ()

@property (weak, nonatomic) IBOutlet PlaceHolderTextView *resultTextView;

@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.resultTextView.placeholder = @"请选择具体案例";
    self.resultTextView.textContainerInset = UIEdgeInsetsMake(12, 20, 12, 20);
}

#pragma mark - action

- (IBAction)httpsSimpleScenario:(id)sender {
}

- (IBAction)httpsWithSNIScenario:(id)sender {
}

- (IBAction)generalScenario:(id)sender {
}

- (IBAction)AFNetworkingScenario:(id)sender {
}

- (IBAction)AFNetworkingWithSNIScenario:(id)sender {
}

- (IBAction)AlamofireScenario:(id)sender {
}

- (IBAction)AlamofireWithSNIScenario:(id)sender {
}

- (IBAction)AVPlayerScenario:(id)sender {
}

@end
