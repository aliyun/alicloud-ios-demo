//
//  UIImage+ColorToImage.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ColorToImage)

// 将UIColor转换为指定尺寸的UIImage
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
