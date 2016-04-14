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
    
    // 本demo仅给出基本网络操作的使用示例。事实上初始化MAC后对网络的操作兼容传统的Native库网络操作。
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL* URL = [NSURL URLWithString:@"http://cas.xxyycc.com/mac/test?expected=echo&mac-header=true"];
        NSHTTPURLResponse* response;
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL
                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        NSData* data;
        // GET请求示例
        // 首请求用于SDK自适应学习加速域名，会走Native网络库逻辑
        data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:nil];
        NSLog(@"response status code: %zd, data length: %ld",response.statusCode,(unsigned long)[data length]);
        NSLog(@"response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        sleep(5);
        // 第二个请求开始会走移动加速逻辑
        data = [NSURLConnection sendSynchronousRequest:request
                                     returningResponse:&response
                                                 error:nil];
        NSLog(@"response status code: %zd, data length: %ld",response.statusCode,(unsigned long)[data length]);
        NSLog(@"response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        // POST请求示例
        NSData* uploadData = [@"Hello, world!Hello, world!" dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:uploadData];
        data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:nil];
        NSLog(@"response status code: %zd, data length: %ld",response.statusCode,(unsigned long)[data length]);
        NSLog(@"response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
