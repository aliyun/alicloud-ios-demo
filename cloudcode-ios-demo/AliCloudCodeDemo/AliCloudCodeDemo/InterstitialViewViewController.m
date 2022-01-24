//
//  InterstitialViewViewController.m
//  AliCloudCodeDemo
//
//  Created by yannan on 2021/2/26.
//

#import "InterstitialViewViewController.h"
#import <AlicloudCloudCode/AliCloudCodeAdInterstitialView.h>
#import <AlicloudCloudCode/AliCloudCodeAdViewProtocol.h>
#import "UIAlertController+CloudCodeDemo.h"


@interface InterstitialViewViewController () <AliCloudCodeAdInterstitialViewDelegate>
@property (nonatomic, strong) AliCloudCodeAdInterstitialView *interstitialAdView;

@property (weak, nonatomic) IBOutlet UIButton *loadBtn;

@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@property (weak, nonatomic) IBOutlet UITextField *slotidTextField;


@property (weak, nonatomic) IBOutlet UILabel *widthLbl;
@property (weak, nonatomic) IBOutlet UISlider *widthSlider;

@property (weak, nonatomic) IBOutlet UILabel *heightLbl;
@property (weak, nonatomic) IBOutlet UISlider *heightSlider;


@end

@implementation InterstitialViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.widthSlider.minimumValue = 0;
    self.widthSlider.maximumValue = [UIScreen mainScreen].bounds.size.width;
    self.widthSlider.value = self.widthSlider.minimumValue;
    self.widthLbl.text = [NSString stringWithFormat:@"宽:%d", (int)self.widthSlider.value];
    
    self.heightSlider.minimumValue = 0;
    self.heightSlider.maximumValue = [UIScreen mainScreen].bounds.size.height;
    self.heightSlider.value = self.heightSlider.minimumValue;
    self.heightLbl.text = [NSString stringWithFormat:@"高:%d", (int)self.heightSlider.value];
    
    
    
}


- (IBAction)startLoad:(id)sender {
    self.showBtn.enabled = NO;
    
    
    
   

    NSString *slotID = self.slotidTextField.text;
    if (slotID.length <= 0) {
        [UIAlertController alicc_showAlertTitle:@"请检查输入" message:@"广告位为空" parentVC:self];
        return;
    }
    
    
    AliCloudCodeAdInterstitialProps *props = [[AliCloudCodeAdInterstitialProps alloc] init];
    props.interstitialType = AliCloudCodeAdInterstitialType_All;
    props.videoMuted = YES;
    props.minVideoDuration = 5;
    props.maxVideoDuration = 10;
    props.adSize = CGSizeMake(self.widthSlider.value, self.heightSlider.value);
    self.interstitialAdView = [[AliCloudCodeAdInterstitialView  alloc] initWithSlotID:slotID interstitialProps:props];
    self.interstitialAdView.adDelegate = self;
    self.interstitialAdView.rootViewController = self;
    [self.interstitialAdView loadAdData];
    

}

- (IBAction)startShow:(id)sender {
    self.showBtn.enabled = NO;
    [self.view endEditing:YES];
    [self.interstitialAdView showInterstitialView];
}

- (IBAction)sliderChanged:(id)sender {
    
    if (sender == self.widthSlider) {
        self.widthLbl.text = [NSString stringWithFormat:@"宽:%d", (int)self.widthSlider.value];
    } else if (sender == self.heightSlider) {
        self.heightLbl.text = [NSString stringWithFormat:@"高:%d", (int)self.heightSlider.value];
    }
    
    
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
