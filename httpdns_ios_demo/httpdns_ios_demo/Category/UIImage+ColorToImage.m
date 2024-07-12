//
//  UIImage+ColorToImage.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/11.
//

#import "UIImage+ColorToImage.h"

@implementation UIImage (ColorToImage)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);

    [color setFill];
    UIRectFill(rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
