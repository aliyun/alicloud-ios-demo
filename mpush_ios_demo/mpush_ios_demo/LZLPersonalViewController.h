//
//  LZLPersonalViewController.h
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/4/1.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudPushSDK/CloudPushSDK.h>
#import "MsgToolBox.h"

@interface LZLPersonalViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *persionalDataTableView;

@end
