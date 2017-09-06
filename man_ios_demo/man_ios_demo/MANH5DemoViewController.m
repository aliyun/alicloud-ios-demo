//
//  MANH5DemoViewController.m
//  man_ios_demo
//
//  Created by 王 羽涵 on 2017/9/6.
//  Copyright © 2017年 com.aliyun.mobile. All rights reserved.
//

#import "MANH5DemoViewController.h"
#import <AlicloudMobileAnalitics/ALBBMAN.h>

@interface MANH5DemoViewController () <UIWebViewDelegate>

@end

@implementation MANH5DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"H5Demo";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = self.view.frame;
    frame.size.height -= 20;
    frame.origin.y    += 20;
    UIWebView *web = [[UIWebView alloc] initWithFrame:frame];
    web.delegate   = self;
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *url     = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"h5demo"
                                                         ofType:@"html"];
    
    NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath
                                                      encoding:NSUTF8StringEncoding
                                                         error:nil];
    
    [web loadHTMLString:htmlContent baseURL:url];
    [self.view addSubview:web];
    
    // Do any additional setup after loading the view.
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSString *scheme = [url scheme];
    
    // js通信
    if ( [@"jsbridge" isEqualToString:scheme] ) {
        if ( [@"custom" isEqualToString:url.host] ) {
            ALBBMANCustomHitBuilder *customBuilder = [[ALBBMANCustomHitBuilder alloc] init];
            // 设置自定义事件标签
            [customBuilder setEventLabel:@"test_event_label"];
            // 设置自定义事件页面名称
            [customBuilder setEventPage:@"test_Page"];
            // 设置自定义事件持续时间
            [customBuilder setDurationOnEvent:12345];
            // 设置自定义事件扩展参数
            [customBuilder setProperty:@"ckey0" value:@"value0"];
            [customBuilder setProperty:@"ckey1" value:@"value1"];
            [customBuilder setProperty:@"ckey2" value:@"value2"];
            ALBBMANTracker *traker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
            // 组装日志并发送
            NSDictionary *dic = [customBuilder build];
            [traker send:dic];
        }
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
