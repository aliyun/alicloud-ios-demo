//
//  AVPlayerScenarioViewController.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/6/5.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "AVPlayerScenarioViewController.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import <AVFoundation/AVFoundation.h>
#import "CustomResourceLoaderDelegate.h"

@interface AVPlayerScenarioViewController ()
@property (weak, nonatomic) IBOutlet UIView *playView;
@property(nonatomic, strong)AVPlayer *player;
@property(nonatomic, strong)CustomResourceLoaderDelegate *resourceLoaderDelegate;

@end

@implementation AVPlayerScenarioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)play:(id)sender {
    if (self.player.rate == 0) {
        [self.player play];
    }
}

- (IBAction)loading:(id)sender {
    NSString *originalUrl = @"https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/file_example_MP4_640_3MG.mp4";
    NSURL *url = [[NSURL alloc]initWithString:originalUrl];
    NSString *resolvedIpAddress = [self resolveAvailableIp:url.host];
    NSString *requestUrl = originalUrl;

    if (resolvedIpAddress) {
        // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
        requestUrl = [originalUrl stringByReplacingOccurrencesOfString:url.host withString:resolvedIpAddress];
        url = [[NSURL alloc]initWithString:requestUrl];
    }

    NSLog(@"requestUrl: %@",requestUrl);
    [self setupAVPlayerWithURL:url host:[[NSURL alloc]initWithString:originalUrl].host];
}

- (IBAction)stop:(id)sender {
    if (self.player.rate == 1) {
        [self.player pause];
    }
}

- (void)setupAVPlayerWithURL:(NSURL *)url host:(NSString *)host {
    // 替换URL Scheme以拦截请求
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    components.scheme = @"customScheme";
    NSURL *customURL = components.URL;

    // 创建 AVURLAsset 并使用自定义的 AVAssetResourceLoaderDelegate
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:customURL options:nil];
    self.resourceLoaderDelegate = [[CustomResourceLoaderDelegate alloc]initWithHost:host Scheme:url.scheme];
    [asset.resourceLoader setDelegate:self.resourceLoaderDelegate queue:dispatch_get_main_queue()];

    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];

    // 设置播放页面
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];

    // 设置播放页面的大小
    layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.playView.frame.size.height);
    layer.backgroundColor = [UIColor clearColor].CGColor;

    // 设置播放窗口和当前视图之间的比例显示内容
    layer.videoGravity = AVLayerVideoGravityResizeAspect;

    [self cleanSublayers: self.playView];
    // 添加播放视图到self.playView
    [self.playView.layer addSublayer:layer];
    // 设置播放的默认音量值
    self.player.volume = 1.0f;
}

- (void)cleanSublayers:(UIView *)playView {
    for (CALayer *layer in playView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
}

- (NSString *)resolveAvailableIp:(NSString *)host {
    HttpDnsService *httpDnsService = [HttpDnsService sharedInstance];
    HttpdnsResult *result = [httpDnsService resolveHostSyncNonBlocking:host byIpType:HttpdnsQueryIPTypeBoth];

    NSLog(@"resolve host result: %@", result);
    if (!result) {
        return nil;
    }

    if (result.hasIpv4Address) {
        return result.firstIpv4Address;
    } else if (result.hasIpv6Address) {
        return [NSString stringWithFormat:@"[%@]", result.firstIpv6Address];
    } else {
        return nil;
    }
}

@end
