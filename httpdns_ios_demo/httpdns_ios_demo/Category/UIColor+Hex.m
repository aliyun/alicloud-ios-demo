//
//  UIColor+Hex.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/11.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    // 去掉字符串开头的 #
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }

    // 字符串必须是6或8个字符长（不包含透明度的6个字符或包含透明度的8个字符）
    if (hexString.length != 6 && hexString.length != 8) {
        return [UIColor clearColor]; // 或者根据你的需求返回 nil 或者其他默认颜色
    }

    // 如果是6个字符长，前面补2个 F 表示不透明
    if (hexString.length == 6) {
        hexString = [@"FF" stringByAppendingString:hexString];
    }

    // 分别取透明度、红、绿、蓝
    unsigned int alpha, red, green, blue;
    NSRange range = NSMakeRange(0, 2);
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&alpha];
    range.location = 2;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&red];
    range.location = 4;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&green];
    range.location = 6;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&blue];

    return [UIColor colorWithRed:(CGFloat)red/255.0 green:(CGFloat)green/255.0 blue:(CGFloat)blue/255.0 alpha:(CGFloat)alpha/255.0];
}

@end
