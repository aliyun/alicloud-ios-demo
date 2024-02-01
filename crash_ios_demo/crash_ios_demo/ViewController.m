//
//  ViewController.m
//  crash_ios_demo
//
//  Created by sky on 2019/8/7.
//  Copyright © 2019 sky. All rights reserved.
//

#import "ViewController.h"
#import <AlicloudHAUtil/AlicloudHAProvider.h>
#import <AlicloudCrash/AlicloudCrashProvider.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// crash
- (IBAction)testCrash:(id)sender {
    // full stack crash
    NSMutableArray *array = @[];
    [array addObject:nil];
}

// abort
- (IBAction)testAbort:(id)sender {
    // abort
    exit(0);
}

// freezing
- (IBAction)testFreezing:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:30];
    });
}


- (IBAction)updateNickName:(id)sender {
    NSString *updateNickName = @"emas-update-nick";
    [AlicloudHAProvider updateNick:updateNickName];
    [AlicloudHAProvider start];
    [self alert:[NSString stringWithFormat:@"updateNickName:%@",updateNickName]];
}

- (void)alert:(NSString *)msgStr {

    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertVc addAction:cancel];
    
    [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:alertVc animated:YES completion:nil];
    
}

// 自定义异常
- (IBAction)customExceptions:(id)sender {
    //上报自定义信息
    [AlicloudCrashProvider configCustomInfoWithKey:@"configCustomInfoWithKey" value:@"customValue"];//配置项：自定义环境信息（configCustomInfoWithKey/value）

    //按异常类型上报自定义信息
    [AlicloudCrashProvider setCrashCallBack:^NSDictionary * _Nonnull(NSString * _Nonnull type) {
        return @{@"key":@"value"};//配置项：异常信息（key/value）
    }];

    //上报自定义错误
    NSError *error = [NSError errorWithDomain:@"customError" code:10001 userInfo:@{@"errorInfoKey":@"errorInfoValue"}];
    [AlicloudCrashProvider reportCustomError:error];//配置项：自定义错误信息（errorWithDomain/code/userInfo）
}

@end
