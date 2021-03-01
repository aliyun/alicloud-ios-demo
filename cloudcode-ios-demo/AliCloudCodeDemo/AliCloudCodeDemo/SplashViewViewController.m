//
//  SplashViewViewController.m
//  AliCloudCodeDemo
//
//  Created by yannan on 2021/2/26.
//

#import "SplashViewViewController.h"
#import <AlicloudCloudCode/AliCloudCodeAdSplashView.h>
#import <AlicloudCloudCode/AliCloudCodeAdViewProtocol.h>

@interface SplashViewViewController () <AliCloudCodeAdSplashViewDelegate>

//插屏广告View
@property (nonatomic, strong) AliCloudCodeAdSplashView *splashView;

@property (weak, nonatomic) IBOutlet UISwitch *fullScreen;

@property (weak, nonatomic) IBOutlet UIButton *loadBtn;

@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@end

@implementation SplashViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


//开屏_全屏模式
static NSString *const splashSlotID_fullscreen = @"566927798737744900";
//开屏_非全屏模式，需要自行保证素材展示区域为2:3的比例
static NSString *const splashSlotID_2_3 = @"566391127667553282";

- (IBAction)startLoad:(id)sender {
    
    self.showBtn.enabled = NO;
    self.splashView = [[AliCloudCodeAdSplashView alloc] initWithSlotID:self.fullScreen.on ? splashSlotID_fullscreen : splashSlotID_2_3 adSize:[UIScreen mainScreen].bounds.size isFullScreen:self.fullScreen.on];
    self.splashView.adDelegate = self;
    
    /*
     非全屏模式开屏广告，所有上部素材比例为2:3 ，底部为自定义区域，需要自行保证上部素材的展示区域为2:3的比例
     如不需要设置自定义区域，开屏广告申请全屏模式即可
     */
    if (!self.fullScreen.on) {
        
        //计算上部素材展示高度
        CGFloat topAreaHegiht = self.splashView.bounds.size.width * (3.0 / 2.0);
        
        //计算自定义view的高度
        CGFloat custViewHeight = self.splashView.bounds.size.height - topAreaHegiht;
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.splashView.bounds.size.width, custViewHeight)];
        customView.backgroundColor = [UIColor systemPinkColor];
        UILabel *customLbl = [[UILabel alloc] init];
        [customLbl setText:@"自定义区域"];
        [customLbl sizeToFit];
        customLbl.center = CGPointMake(customView.frame.size.width / 2, customView.frame.size.height / 2);
        [customView addSubview:customLbl];
        
        //设置自定义区域
        [self.splashView setCustomView:customView viewHeight:custViewHeight];
    }
    
    
    [self.splashView loadAdData];
}


- (IBAction)startShow:(id)sender {
    [self.navigationController.view addSubview:self.splashView];
    self.showBtn.enabled = NO;
}

#pragma mark - AliCloudCodeAdViewProtocol
/// 广告开始加载
/// @param aliccAdView aliccAdView
- (void)aliccAdViewLoadStart:(UIView *)aliccAdView {
    
}


/// 广告数据源加载成功
/// @param aliccAdView aliccAdView
- (void)aliccAdViewLoadSuccess:(UIView *)aliccAdView {
    
}


/// 广告数据源加载失败
/// @param aliccAdView aliccAdView
/// @param error error
- (void)aliccAdViewLoadFail:(UIView *)aliccAdView error:(NSError * __nullable)error {
    NSLog(@"广告加载失败：%@", error.description);
}


/// 广告渲染成功
/// @param aliccAdView aliccAdView
- (void)aliccAdViewRenderSuccess:(UIView *)aliccAdView {
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




#pragma mark - AliCloudCodeAdSplashViewDelegate

/// 开屏广告: 广告点击事件
/// @param splashAdView splashAdView
- (void)aliccAdSplashViewDidClick:(AliCloudCodeAdSplashView *)splashAdView {
    NSLog(@"开屏广告点击事件");
}

/// 开屏广告: "跳过"按钮点击
/// @param splashAdView splashAdView
- (void)aliccAdSplashViewDidClickSkip:(AliCloudCodeAdSplashView *)splashAdView {
    NSLog(@"开屏广告'跳过'按钮点击");
}

/// 开屏广告: 倒计时结束事件
/// @param splashAdView splashAdView
- (void)aliccAdSplashViewCountdownToZero:(AliCloudCodeAdSplashView *)splashAdView {
    NSLog(@"开屏广告倒计时结束事件");
}


@end
