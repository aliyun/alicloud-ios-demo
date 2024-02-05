//
//  ViewController.m
//  TestPublicYunUpdate
//
//  Created by ASP on 2020/5/28.
//  Copyright © 2020 ASP. All rights reserved.
//

#import "ViewController.h"
#import <AlicloudUpdate/AlicloudUpdate.h>
#import <UTDID/UTDevice.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//     CFShow(infoDictionary);
    // app名称
     NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
     // app版本
     NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
     // app build版本
     NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];

//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    self.textField.text = [UTDevice utdid];
    self.textView.text = [NSString stringWithFormat:@"AppName：%@\nAppVersion: %@\nAppBuild：%@",appCurName,appCurVersion,appCurVersionNum];
    
    
}

- (IBAction)clickButton:(id)sender {
    [AlicloudUpdate checkAndUpdateNewVersion];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}

@end
