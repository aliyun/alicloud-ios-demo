//
//  InformationCCPTableViewCell.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/11/1.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "InformationCCPTableViewCell.h"

@implementation InformationCCPTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];

    self.textLabel.font = [UIFont systemFontOfSize:16 weight:500];
    self.textLabel.textColor = [UIColor colorWithHexString:@"#31383E"];
    self.textLabel.text = @"自有通道开关";

    CGRect frame = self.textLabel.frame;
    frame.origin.x = 16;
    self.textLabel.frame = frame;
}

@end
