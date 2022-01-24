//
//  UIView+CloudCodeDemo.h
//  AliCloudCodeDemo
//
//  Created by yannan on 2022/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CloudCodeDemo)

@property (nonatomic) CGFloat cloudCode_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat cloudCode_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat cloudCode_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat cloudCode_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat cloudCode_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat cloudCode_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat cloudCode_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat cloudCode_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint cloudCode_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  cloudCode_size;        ///< Shortcut for frame.size.

- (void)cloudCode_removeAllSubViews;

@end

NS_ASSUME_NONNULL_END
