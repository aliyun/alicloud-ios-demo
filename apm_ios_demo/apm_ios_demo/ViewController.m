//
//  ViewController.m
//  apm_ios_demo
//
//  Created by sky on 2019/10/11.
//  Copyright © 2019 aliyun. All rights reserved.
//

#import "ViewController.h"
#import "ALC1ViewController.h"
#import "ALC2ViewController.h"
#import "ALC3ViewController.h"
#import <AlicloudHAUtil/AlicloudHAProvider.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)page1:(id)sender {
    
    ALC1ViewController *vc1 = [[ALC1ViewController alloc] init];
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (IBAction)page2:(id)sender {
    ALC2ViewController *vc1 = [[ALC2ViewController alloc] init];
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (IBAction)page3:(id)sender {
    ALC3ViewController *vc1 = [[ALC3ViewController alloc] init];
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (IBAction)networkRequest:(id)sender {
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
}

- (void)alert:(NSString *)msgStr {

    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertVc addAction:cancel];
    
    [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:alertVc animated:YES completion:nil];
    
}

@end
