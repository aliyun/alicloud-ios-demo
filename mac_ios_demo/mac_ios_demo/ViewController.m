//
//  ViewController.m
//  mac_ios_demo
//
//  Created by nanpo.yhl on 15/10/9.
//  Copyright (c) 2015年 com.aliyun.mobile. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL* URL = [NSURL URLWithString:@"http://cas.xxyycc.com/mbaas/test"];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    for (int i = 0; i < 10; i ++) {
        NSHTTPURLResponse* response;
        NSData* data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:nil];
        NSLog(@"response %@, data length %ld",response,(unsigned long)[data length]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
