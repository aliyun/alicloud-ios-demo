//
//  InformationTableViewCell.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/11/1.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "InformationTableViewCell.h"

@interface InformationTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIButton *detailCopyButton;

@end

@implementation InformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setTitle:(NSString *)title detail:(NSString *)detail {
    self.titleLabel.text = title;
    self.detailLabel.text = detail;
}

- (void)showCopyButton {
    self.detailCopyButton.hidden = NO;
}

- (void)hiddenCopyButton {
    self.detailCopyButton.hidden = YES;
}

- (IBAction)copyDetailAction:(id)sender {
    // 获取系统通用的剪切板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    // 将字符串放入剪切板
    pasteboard.string = self.detailTextLabel.text;

    [MsgToolBox showAlert:@"" content:@"已复制到剪切板"];
}


@end
