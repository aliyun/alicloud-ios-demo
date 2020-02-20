//
//  ViewController.m
//  tlog_ios_demo
//
//  Created by sky on 2019/10/11.
//  Copyright © 2019 aliyun. All rights reserved.
//

#import "ViewController.h"
#import <TRemoteDebugger/TLogBiz.h>
#import <TRemoteDebugger/TLogFactory.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)logClick:(id)sender {
    
    TLogBiz *log = [TLogFactory createTLogForModuleName:@"YourModuleName"];
    [log error:@"error message"];
    [log warn:@"warn message"];
    [log debug:@"debug message"];
    [log info:@"info message"];
    
}

@end
