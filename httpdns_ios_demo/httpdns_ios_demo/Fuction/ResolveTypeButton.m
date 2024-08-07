//
//  ResolveTypeButton.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/11.
//

#import "ResolveTypeButton.h"

@interface ResolveTypeButton()

@property(nonatomic, strong)UIImageView *selectedCheckMark;

@end

@implementation ResolveTypeButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupConfigure];
}

- (void)setupConfigure {
    self.layer.cornerRadius = 8;
    self.layer.borderWidth = 1;

    self.selectedCheckMark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CheckBox_YES"]];
    self.selectedCheckMark.frame = CGRectMake(self.frame.size.width - 18, self.frame.size.height - 18, 18, 18);
    [self addSubview:self.selectedCheckMark];

    [self changeState];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected: selected];
    [self changeState];
}

- (void)changeState {
    self.layer.borderColor = self.isSelected ? [UIColor colorWithHexString:@"#1B58F4"].CGColor : [UIColor colorWithHexString:@"#E6E8EB"].CGColor;
    [self.selectedCheckMark setHidden:!self.isSelected];
}

@end
