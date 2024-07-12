//
//  UIColor+Hex.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

// 将十六进制颜色字符串转换为UIColor对象
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
