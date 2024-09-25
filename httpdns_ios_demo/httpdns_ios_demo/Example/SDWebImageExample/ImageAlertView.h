//
//  ImageAlertView.h
//  httpdns_ios_demo
//
//  Created by wy on 2024/9/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ImageViewHandler)(UIImageView *imageView);

@interface ImageAlertView : UIView

+ (void)imageAlertShow:(ImageViewHandler)handler;

@end

NS_ASSUME_NONNULL_END
