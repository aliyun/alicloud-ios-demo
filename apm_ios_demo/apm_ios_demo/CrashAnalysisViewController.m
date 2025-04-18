//
//  CrashAnalysisViewController.m
//  apm_ios_demo
//
//  Created by Miracle on 2025/4/16.
//  Copyright © 2025 aliyun. All rights reserved.
//

#import "CrashAnalysisViewController.h"
#import <AlicloudApmCrashAnalysis/AlicloudApmCrashAnalysis.h>

@interface CrashAnalysisViewController ()

@end

@implementation CrashAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 全堆栈crash
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

// 自定义异常
- (IBAction)customExceptions:(id)sender {
    //上报自定义维度
    [[EAPMCrashAnalysis crashAnalysis] setCustomValue:@"customValue" forKey:@"configCustomInfoWithKey"];

    //上报自定义错误
    NSError *error = [NSError errorWithDomain:@"customError" code:10001 userInfo:@{@"errorInfoKey":@"errorInfoValue"}];
    [[EAPMCrashAnalysis crashAnalysis] recordError:error];
}

// 更新nick
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

@end
