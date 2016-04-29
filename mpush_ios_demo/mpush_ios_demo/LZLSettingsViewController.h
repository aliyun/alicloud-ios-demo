//
//  LZLSettingsViewController.h
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/3/31.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgToolBox.h"

@interface LZLSettingsViewController : UIViewController <UITextFieldDelegate>

// 用户按下Return隐藏软键盘
- (IBAction)TextField_DidEndOnExit:(id)sender;

@end
