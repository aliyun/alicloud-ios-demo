//
//  MsgToolBox.m
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/3/31.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "MsgToolBox.h"

@implementation MsgToolBox

+ (void) showAlert:(NSString *)title content:(NSString *)content {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
