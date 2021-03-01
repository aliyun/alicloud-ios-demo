//
//  InterstitialViewViewController.m
//  AliCloudCodeDemo
//
//  Created by yannan on 2021/2/26.
//

#import "InterstitialViewViewController.h"
#import <AlicloudCloudCode/AliCloudCodeAdInterstitialView.h>
#import <AlicloudCloudCode/AliCloudCodeAdViewProtocol.h>

@interface InterstitialViewViewController () <AliCloudCodeAdInterstitialViewDelegate>
@property (nonatomic, strong) AliCloudCodeAdInterstitialView *interstitialView;

@property (weak, nonatomic) IBOutlet UIButton *loadBtn;

@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@property (weak, nonatomic) IBOutlet UISegmentedControl *sizeControl;

@end

@implementation InterstitialViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)startLoad:(id)sender {
    self.showBtn.enabled = NO;
    
    NSArray *sizeArray = @[
        [NSValue valueWithCGSize:CGSizeMake(300, 450)],
        [NSValue valueWithCGSize:CGSizeMake(300, 300)],
        [NSValue valueWithCGSize:CGSizeMake(300, 200)],
        [NSValue valueWithCGSize:CGSizeMake(480, 270)]];
    
    NSArray *slotIDArray = @[@"566928319200410624", @"566928608783547394", @"566928943870682114", @"566953471695099908"];
    
    CGSize adSize = [((NSValue *)[sizeArray objectAtIndex:self.sizeControl.selectedSegmentIndex]) CGSizeValue];
    //处理超过屏幕的状态
    if (adSize.width > self.view.frame.size.width) {
        adSize.height = adSize.height / adSize.width * self.view.frame.size.width;
        adSize.width = self.view.frame.size.width;
    }
    NSString *slotID = [slotIDArray objectAtIndex:self.sizeControl.selectedSegmentIndex];
    
    self.interstitialView = [[AliCloudCodeAdInterstitialView alloc] initWithSlotID:slotID adSize:adSize];
    self.interstitialView.adDelegate = self;
    [self.interstitialView loadAdData];
    
}

- (IBAction)startShow:(id)sender {
    [self.interstitialView showInterstitialView];
    self.showBtn.enabled = NO;
}

#pragma mark -
/// 广告开始加载
/// @param aliccAdView aliccAdView
- (void)aliccAdViewLoadStart:(UIView *)aliccAdView {
    NSLog(@"广告开始加载");
}


/// 广告数据源加载成功
/// @param aliccAdView aliccAdView
- (void)aliccAdViewLoadSuccess:(UIView *)aliccAdView {
    NSLog(@"广告数据源加载成功");
}


/// 广告数据源加载失败
/// @param aliccAdView aliccAdView
/// @param error error
- (void)aliccAdViewLoadFail:(UIView *)aliccAdView error:(NSError * __nullable)error {
    NSLog(@"广告数据源加载失败：%@", error.description);
}


/// 广告渲染成功
/// @param aliccAdView aliccAdView
- (void)aliccAdViewRenderSuccess:(UIView *)aliccAdView {
    NSLog(@"广告渲染成功");
    self.showBtn.enabled = YES;
}


/// 广告渲染失败
/// @param aliccAdView aliccAdView
/// @param error error
- (void)aliccAdViewRenderFail:(UIView *)aliccAdView error:(NSError * __nullable)error {
    NSLog(@"广告渲染失败：%@", error.description);
}


/// 广告将要展示
/// @param aliccAdView aliccAdView
- (void)aliccAdViewWillVisible:(UIView *)aliccAdView {
    
}


/// 广告展示
/// @param aliccAdView aliccAdView
- (void)aliccAdViewDidVisible:(UIView *)aliccAdView {
    
}


/// 广告将要关闭
/// @param aliccAdView aliccAdView
- (void)aliccAdViewWillClose:(UIView *)aliccAdView {
    
}


/// 广告关闭
/// @param aliccAdView aliccAdView
- (void)aliccAdViewDidClose:(UIView *)aliccAdView {
    
}



#pragma mark - AliCloudCodeAdInterstitialViewDelegate

/// 插屏广告: 广告点击事件
/// @param interstitialAdView interstitialAdView
- (void)aliccAdInterstitialViewDidClick:(AliCloudCodeAdInterstitialView *)interstitialAdView {
    NSLog(@"插屏广告点击事件");
}


/// 插屏广告: "关闭"按钮点击事件
/// @param interstitialAdView interstitialAdView
- (void)aliccAdInterstitialViewCloseClick:(AliCloudCodeAdInterstitialView *)interstitialAdView {
    NSLog(@"插屏广告'关闭'按钮点击");
}


@end
