//
//  SDKConfigViewController.m
//  mpush_ios_demo
//
//  Created by Miracle on 2025/5/13.
//  Copyright © 2025 alibaba. All rights reserved.
//

#import "SDKConfigViewController.h"
#import "ConfigsHistoryView.h"

@interface SDKConfigViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *envSegment;

@property (weak, nonatomic) IBOutlet UITextField *appKeyTextfield;

@property (weak, nonatomic) IBOutlet UITextField *secretKeyTextfield;

@end

@implementation SDKConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchAndDisplayConfigs];

    // 设置输入框代理
    self.appKeyTextfield.delegate = self;
    self.secretKeyTextfield.delegate = self;
}

- (void)fetchAndDisplayConfigs {
    NSString *appKey = (NSString *)[CommonTools userDefaultGet:kAppKey];
    NSString *secretKey = (NSString *)[CommonTools userDefaultGet:kSecretKey];
    NSNumber *envIndexNumber = [CommonTools userDefaultGet:kSDKEnv];

    if (!appKey || !secretKey || !envIndexNumber) {
        return;
    }

    self.envSegment.selectedSegmentIndex = [envIndexNumber integerValue];
    self.appKeyTextfield.text = appKey;
    self.secretKeyTextfield.text = secretKey;
}

- (IBAction)chooseHistoryConfig:(id)sender {
    __weak typeof(self) weakSelf = self;
    [ConfigsHistoryView showHistoryList:^(NSDictionary * _Nonnull configs) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *appKey = configs[@"appKey"];
        NSString *secretKey = configs[@"secretKey"];
        NSNumber *envNumber = configs[@"env"];

        strongSelf.envSegment.selectedSegmentIndex = [envNumber integerValue];
        strongSelf.appKeyTextfield.text = appKey;
        strongSelf.secretKeyTextfield.text = secretKey;
    }];
}

- (IBAction)saveAndExit:(id)sender {
    if ([CommonTools textFiledIsEmpty:self.appKeyTextfield]) {
        [MsgToolBox showAlert:nil content:@"appKey不能为空"];
        return;
    }

    if ([CommonTools textFiledIsEmpty:self.secretKeyTextfield]) {
        [MsgToolBox showAlert:nil content:@"secretKey不能为空"];
        return;
    }

    NSString *appKey = [self.appKeyTextfield.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *secretKey = [self.secretKeyTextfield.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSNumber *envIndexNumber = [[NSNumber alloc] initWithInteger:self.envSegment.selectedSegmentIndex];
    [CommonTools userDefaultSetObject:appKey forKey:kAppKey];
    [CommonTools userDefaultSetObject:secretKey forKey:kSecretKey];
    [CommonTools userDefaultSetObject:envIndexNumber forKey:kSDKEnv];

    NSMutableArray *configs = [(NSArray *)[CommonTools userDefaultGet:kConfigsHistory] mutableCopy];
    if (!configs) {
        configs = [NSMutableArray arrayWithCapacity:1];
    }

    NSDictionary *config = @{
        @"appKey":appKey,
        @"secretKey":secretKey,
        @"env":[[NSNumber alloc] initWithInteger:self.envSegment.selectedSegmentIndex]
    };
    [configs addObject:config];
    [CommonTools userDefaultSetObject:configs forKey:kConfigsHistory];

    // 弹框提示退出APP，给userDefault存储争取时间
    [CommonTools showTitle:@"提示" message:@"即将退出APP" handle:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
