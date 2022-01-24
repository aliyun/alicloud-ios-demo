//
//  SplashViewViewController.m
//  AliCloudCodeDemo
//
//  Created by yannan on 2021/2/26.
//

#import "SplashViewViewController.h"
#import <AlicloudCloudCode/AliCloudCodeAdSplashView.h>
#import <AlicloudCloudCode/AliCloudCodeAdViewProtocol.h>
#import "UIColor+CloudCodeDemo.h"
#import "UIView+CloudCodeDemo.h"
#import <AlicloudCloudCode/AliccAdSplashZoomOutView.h>


@interface SplashViewViewController () <AliCloudCodeAdSplashViewDelegate>


@property (nonatomic, assign) CGFloat customViewHeight;


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
static NSString *const splashSlotID_fullscreen = @"全屏广告位";
//开屏_非全屏模式，需要自行保证素材展示区域为2:3的比例
static NSString *const splashSlotID_2_3 = @"半屏广告位";

- (IBAction)startLoad:(id)sender {
    
    self.showBtn.enabled = NO;
    
    AliCloudCodeAdSplashProps *splashProps = [[AliCloudCodeAdSplashProps alloc] init];
    //设置获取广告样式
    splashProps.splashType =  AliCloudCodeAdSplashType_All;
    //设置尺寸
    splashProps.adSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    splashProps.videoMuted = YES;
    splashProps.minVideoDuration = 3;
    splashProps.maxVideoDuration = 10;
    
    
    self.splashView = [[AliCloudCodeAdSplashView alloc] initWithSlotID:self.fullScreen.on?splashSlotID_fullscreen:splashSlotID_2_3 splashProps:splashProps];
    
    
    self.splashView.adDelegate = self;
    self.splashView.rootViewController = self;

    
    /*
     非全屏模式开屏广告，所有上部素材比例为2:3 ，底部为自定义区域，需要自行保证上部素材的展示区域为2:3的比例
     如不需要设置自定义区域，开屏广告申请全屏模式即可
     */
    if (!self.fullScreen.on) {
        
        //如果使用非全屏展示，设置自定义展示区域，需要尽量保证开屏素材区域比例为2:3
        CGFloat areaHeight = [UIScreen mainScreen].bounds.size.width * (3.0 / 2.0);
        self.customViewHeight = [UIScreen mainScreen].bounds.size.height - areaHeight;

        
        //自定义view
        UIView *tempCustomView = [[UIView alloc] init];
        tempCustomView.backgroundColor = [UIColor cloudCodeDemo_colorWithHexString:@"#ACACAC"];
        
        
        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.cloudCode_size = CGSizeMake(45, 45);
        iconImage.image = [UIImage imageNamed:@"app_logo"];
        [tempCustomView addSubview:iconImage];
        
        
        
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.text = @"云码";
        [titleLbl setFont:[UIFont systemFontOfSize:24]];
        [titleLbl setTextColor:[UIColor cloudCodeDemo_colorWithHexString:@"#5D5D5D"]];
        [titleLbl sizeToFit];
        [tempCustomView addSubview:titleLbl];
        
        
        UILabel *desLbl = [[UILabel alloc] init];
        desLbl.text = @"更智能的的商业推广";
        [desLbl setFont:[UIFont systemFontOfSize:12]];
        [desLbl setTextColor:[UIColor cloudCodeDemo_colorWithHexString:@"#5D5D5D"]];
        [desLbl sizeToFit];
        [tempCustomView addSubview:desLbl];
        
        CGFloat betweenMargin = 20;
        CGFloat leftMargin = (self.splashView.cloudCode_width - (iconImage.cloudCode_width + 20 + desLbl.cloudCode_width)) / 2;
        
        iconImage.cloudCode_left = leftMargin;
        iconImage.cloudCode_centerY = self.customViewHeight / 2;
        
        titleLbl.cloudCode_left = iconImage.cloudCode_right + betweenMargin;
        titleLbl.cloudCode_top = iconImage.cloudCode_top;
        
        desLbl.cloudCode_left = titleLbl.cloudCode_left;
        desLbl.cloudCode_bottom = iconImage.cloudCode_bottom;
        
        [self.splashView setCustomView:tempCustomView viewHeight:self.customViewHeight];
        
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
    
    //V+广告
    if (self.splashView.splashZoomOutView) {
        self.splashView.splashZoomOutView.frame = CGRectMake(self.view.cloudCode_width - 100, self.view.cloudCode_height - 150, 75, 139);
        [self.navigationController.view insertSubview:self.splashView.splashZoomOutView belowSubview:self.splashView];
    }
    
}

/// 开屏广告: 倒计时结束事件
/// @param splashAdView splashAdView
- (void)aliccAdSplashViewCountdownToZero:(AliCloudCodeAdSplashView *)splashAdView {
    NSLog(@"开屏广告倒计时结束事件");
    
    if (self.splashView.splashZoomOutView) {
        self.splashView.splashZoomOutView.frame = CGRectMake(self.view.cloudCode_width - 100, self.view.cloudCode_height - 150, 75, 139);
        [self.navigationController.view insertSubview:self.splashView.splashZoomOutView belowSubview:self.splashView];
    }
}


@end
