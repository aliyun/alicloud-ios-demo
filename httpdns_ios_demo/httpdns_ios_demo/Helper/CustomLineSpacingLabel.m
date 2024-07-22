//
//  CustomLineSpacingLabel.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/19.
//

#import "CustomLineSpacingLabel.h"

@implementation CustomLineSpacingLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupLineSpacing];
}

- (void)setupLineSpacing {
    if (self.text == nil) {
        return;
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName: paragraphStyle,
        NSFontAttributeName: self.font,
    };

    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];

    self.attributedText = attributedText;
}

@end
