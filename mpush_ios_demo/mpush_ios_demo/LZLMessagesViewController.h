//
//  LZLMessagesViewController.h
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/4/1.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZLMessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *pushMessageTableView;

@end
