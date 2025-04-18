//
//  PerformanceViewController.m
//  apm_ios_demo
//
//  Created by sky on 2019/10/11.
//  Copyright © 2019 aliyun. All rights reserved.
//

#import "PerformanceViewController.h"

#import "ALC1ViewController.h"
#import "ALC2ViewController.h"
#import "ALC3ViewController.h"

@interface PerformanceViewController ()

@end

@implementation PerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)page1:(UIButton *)sender {
    ALC1ViewController *vc1 = [[ALC1ViewController alloc] init];
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (IBAction)page2:(id)sender {
    ALC2ViewController *vc2 = [[ALC2ViewController alloc] init];
    [self.navigationController pushViewController:vc2 animated:YES];
}

- (IBAction)page3:(id)sender {
    ALC3ViewController *vc3 = [[ALC3ViewController alloc] init];
    [self.navigationController pushViewController:vc3 animated:YES];
}

- (IBAction)networkRequest:(id)sender {
    for (int i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *urlStr = @"https://www.baidu.com/";
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
            NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    NSString *str = [NSString stringWithFormat:@"触发:%@，error:%@",urlStr,error];
                    [self alert:str];
                } else {
                    [self alert: [NSString stringWithFormat:@"触发:%@，success",urlStr]];
                }
            }];
            [task resume];
        });
    }
}

- (void)alert:(NSString *)msgStr {
    if (self.presentedViewController) {
        // 已经有一个视图控制器被展示
        return;
    }
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:cancel];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

@end
