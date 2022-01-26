//
//  BannerViewController.m
//  AliCloudCodeDemo
//
//  Created by yannan on 2021/2/26.
//

#import "BannerViewController.h"
#import <AlicloudCloudCode/AliCloudCodeAdBannerView.h>
#import <AlicloudCloudCode/AliCloudCodeAdViewProtocol.h>
#import "UIAlertController+CloudCodeDemo.h"

@interface BannerViewController () <AliCloudCodeAdBannerViewDelegate>


@property (nonatomic, strong) AliCloudCodeAdBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UIButton *loadBtn;

@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@property (weak, nonatomic) IBOutlet UISwitch *loopSwitch;

@property (weak, nonatomic) IBOutlet UITextField *loopIntervalTextField;
@property (weak, nonatomic) IBOutlet UITextField *slotTextField;

@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (IBAction)startLoad:(id)sender {
    
    
    self.showBtn.enabled = NO;
    
    NSString *slotID = self.slotTextField.text;
    if (slotID.length <= 0) {
        [UIAlertController alicc_showAlertTitle:@"请检查输入" message:@"广告位为空" parentVC:self];
        return;
    }
    
    self.bannerView = [[AliCloudCodeAdBannerView alloc] initWithSlotID:self.slotTextField.text adSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, 80)];
    self.bannerView.adDelegate = self;
    if (self.loopSwitch.on) {
        self.bannerView.loopInterval = [self.loopIntervalTextField.text intValue];
    }
    [self.bannerView loadAdData];
}


- (IBAction)startShow:(id)sender {
    [self.view addSubview:self.bannerView];
    self.bannerView.center = self.view.center;
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



#pragma mark - AliCloudCodeAdBannerViewDelegate


/// banner广告: 广告点击事件
/// @param bannerAdView bannerAdView
- (void)aliccAdBannerViewDidClick:(AliCloudCodeAdBannerView *)bannerAdView {
    NSLog(@"广告点击事件");
}


/// banner广告: "关闭"按钮点击事件
/// @param bannerAdView bannerAdView
- (void)aliccAdBannerViewCloseClick:(AliCloudCodeAdBannerView *)bannerAdView {
    NSLog(@"广告'关闭'按钮点击事件");
}



@end
