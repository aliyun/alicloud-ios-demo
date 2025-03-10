//
//  ViewController.m
//  crash_ios_demo
//
//  Created by sky on 2019/8/7.
//  Copyright © 2019 sky. All rights reserved.
//

#import "ViewController.h"
#import "AlicloudApmCrashAnalysis/AlicloudApmCrashAnalysis.h"

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
    abort();
}

// freezing
- (IBAction)testFreezing:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:30];
    });
}


- (IBAction)updateNickName:(id)sender {
    NSString *updateNickName = @"emas-update-nick";
    [[EAPMApm defaultApm] setUserNick:updateNickName];
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
    //上报自定义维度
    [[EAPMCrashAnalysis crashAnalysis] setCustomValue:@"customValue" forKey:@"configCustomInfoWithKey"];

    //上报自定义错误
    NSError *error = [NSError errorWithDomain:@"customError" code:10001 userInfo:@{@"errorInfoKey":@"errorInfoValue"}];
    [[EAPMCrashAnalysis crashAnalysis] recordError:error];
}

@end
