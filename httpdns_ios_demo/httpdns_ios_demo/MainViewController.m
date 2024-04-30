//
//  MainViewController.m
//  httpdns_ios_demo
//
//  入口ViewController
//  Created by DaveLam on 16/7/3.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "MainViewController.h"
#import "CommonScene.h"
#import "HTTPSScene.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>


@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)beginCommonScenceQuery:(id)sender {
    [self cleanTextView:nil];
    NSString *originalUrl = @"http://www.aliyun.com";
    [CommonScene beginQuery:originalUrl];
    
    NSUInteger delaySeconds = 1;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:originalUrl];
        HttpDnsService *httpdns = [HttpDnsService sharedInstance];
        NSString *ip = [httpdns getIpByHostAsyncInURLFormat:url.host];
        NSString *text;
        
        if (ip) {
            text = [NSString stringWithFormat:@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", ip, url.host];
        } else {
            text = [NSString stringWithFormat:@"Get IP for host(%@) from HTTPDNS failed!", url.host];
        }
        self.textView.text = text;
        
    });
}

- (IBAction)beginHTTPSSceneQuery:(id)sender {
    [self cleanTextView:nil];
    
        NSString *originalUrl = @"https://www.apple.com";

    [[HTTPSScene new] beginQuery:originalUrl];

    NSUInteger delaySeconds = 1;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        HttpDnsService *httpdns = [HttpDnsService sharedInstance];
        NSURL *url = [NSURL URLWithString:originalUrl];
        NSString *ip = [httpdns getIpByHostAsyncInURLFormat:url.host];
        NSString *text;
        if (ip) {
            text = [NSString stringWithFormat:@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", ip, url.host];
        } else {
            text = [NSString stringWithFormat:@"Get IP for host(%@) from HTTPDNS failed!", url.host];
        }
        self.textView.text = text;
        
    });
    
}

- (IBAction)cleanTextView:(id)sender {
    self.textView.text = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
