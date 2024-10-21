//
//  SettingViewController.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/16.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "SettingViewController.h"
#import "CustomAlertView.h"
#import "CustomToastUtil.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)limitNoteAction:(id)sender {
    [CustomAlertView showLimitNoteAlertView];
}


@end
