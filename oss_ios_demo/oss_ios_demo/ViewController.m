//
//  ViewController.m
//  oss_ios_demo
//
//  Created by zhouzhuo on 9/14/15.
//  Copyright (c) 2015 zhouzhuo. All rights reserved.
//

#import "ViewController.h"
#import "AliyunOSSDemo.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *upload;
@property (strong, nonatomic) IBOutlet UIButton *download;
@property (strong, nonatomic) IBOutlet UIButton *resumableUpload;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // 初始化各种设置
    [[AliyunOSSDemo sharedInstance] setupEnvironment];

    [_upload addTarget:self action:@selector(clickUpload:) forControlEvents:UIControlEventTouchUpInside];
    [_download addTarget:self action:@selector(clickDownload:) forControlEvents:UIControlEventTouchUpInside];
    [_resumableUpload addTarget:self action:@selector(clickResumableUpload:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickUpload:(id)sender {
    [[AliyunOSSDemo sharedInstance] uploadObjectAsync];
}

- (void)clickDownload:(id)sender {
    [[AliyunOSSDemo sharedInstance] downloadObjectAsync];
}

- (void)clickResumableUpload:(id)sender {
    [[AliyunOSSDemo sharedInstance] resumableUpload];
}
@end
