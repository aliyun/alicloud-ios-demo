//
//  AVPlayerAlertView.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/24.
//

#import "AVPlayerAlertView.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface AVPlayerAlertView()

@property(nonatomic, strong)UIView *shadeView;
@property(nonatomic, strong)AVPlayer *player;

@end

@implementation AVPlayerAlertView

+ (void)AVPlayerAlertShow:(AVPlayer *)player {
    AVPlayerAlertView *alertView = [[AVPlayerAlertView alloc]initWithLayer:player];
    [alertView show];
}

- (instancetype)initWithLayer:(AVPlayer *)player {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        [self setupViews:player];
    }
    return self;
}

- (void)setupViews:(AVPlayer *)player {
    [self addSubview:self.shadeView];

    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, (kScreenHeight - kScreenWidth)/2, kScreenWidth - 20, kScreenWidth - 20)];
    backgroundView.layer.cornerRadius = 8;
    backgroundView.layer.masksToBounds = YES;
    backgroundView.backgroundColor = UIColor.whiteColor;
    [self addSubview:backgroundView];

    UIView *playView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, kScreenWidth - 20 - 44)];
    playView.backgroundColor = UIColor.blackColor;
    [backgroundView addSubview:playView];

    self.player = player;
    // 设置播放页面
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    // 设置播放页面的大小
    layer.frame = CGRectMake(0, 0, playView.frame.size.width, playView.frame.size.height);
    layer.backgroundColor = [UIColor clearColor].CGColor;
    // 设置播放窗口和当前视图之间的比例显示内容
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    // 添加播放视图到playView
    [self cleanSublayers: playView];
    [playView.layer addSublayer:layer];

    UIButton *playButton = [[UIButton alloc]initWithFrame:CGRectMake(0, playView.frame.size.height, (kScreenWidth - 20)/2, 44)];
    [playButton setTitle:@"play" forState:UIControlStateNormal];
    [playButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:playButton];

    UIButton *stopButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 20)/2, playView.frame.size.height, (kScreenWidth - 20)/2, 44)];
    [stopButton setTitle:@"stop" forState:UIControlStateNormal];
    [stopButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:stopButton];

    UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, playView.frame.size.height, kScreenWidth - 20, 1)];
    horizontalLine.backgroundColor = UIColor.grayColor;
    [backgroundView addSubview:horizontalLine];

    UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth - 20)/2, playView.frame.size.height, 1, 44)];
    verticalLine.backgroundColor = UIColor.grayColor;
    [backgroundView addSubview:verticalLine];

    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 20, backgroundView.frame.origin.y + backgroundView.frame.size.height + 20, 40, 40)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"Close_Alert"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
}

- (void)play {
    if (self.player.rate == 0) {
        [self.player play];
    }
}

- (void)stop {
    if (self.player.rate == 1) {
        [self.player pause];
    }
}

- (void)close {
    [self removeFromSuperview];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)cleanSublayers:(UIView *)playView {
    for (CALayer *layer in playView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
}

#pragma mark - lazy load

- (UIView *)shadeView {
    if (!_shadeView) {
        _shadeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _shadeView.backgroundColor = [UIColor colorWithHexString:@"#404345"];
        _shadeView.alpha = 0.4;
    }
    return _shadeView;
}

@end
