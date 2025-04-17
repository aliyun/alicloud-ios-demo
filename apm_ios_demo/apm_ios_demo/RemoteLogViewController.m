//
//  RemoteLogViewController.m
//  apm_ios_demo
//
//  Created by Miracle on 2025/4/17.
//  Copyright © 2025 aliyun. All rights reserved.
//

#import "RemoteLogViewController.h"
#import <AlicloudApmRemoteLog/AlicloudApmRemoteLog.h>

@interface RemoteLogViewController ()

@end

@implementation RemoteLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)creatLog:(id)sender {
    EAPMRemoteLog *log = [[EAPMRemoteLog alloc] initWithModuleName:@"YourModuleName"];
    [log error:@"error message"];
    [log warn:@"warn message"];
    [log debug:@"debug message"];
    [log info:@"info message"];
}

- (IBAction)updateLog:(id)sender {
    [EAPMRemoteLog uploadTLog:@"主动上报"];
}

@end
