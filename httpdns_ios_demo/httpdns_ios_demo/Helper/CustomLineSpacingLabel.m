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

    self.layer.borderColor = [UIColor colorWithHexString:@"#A7BCCE"].CGColor;
    self.layer.borderWidth = 1;
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
        NSFontAttributeName: self.font
    };

    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];

    self.attributedText = attributedText;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    // 将 rect 调整为考虑内边距后的大小
    CGRect paddedRect = UIEdgeInsetsInsetRect(rect, insets);

    // 调用父类的方法绘制文本
    [super drawTextInRect:paddedRect];
}

@end
