//
//  UIColor+CloudCodeDemo.h
//  AliCloudCodeDemo
//
//  Created by yannan on 2022/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CloudCodeDemo)

+ (nullable UIColor *)cloudCodeDemo_colorWithHexString:(NSString *)hexStr;


+ (UIColor *)cloudCodeDemo_randomColor;

@end

NS_ASSUME_NONNULL_END
