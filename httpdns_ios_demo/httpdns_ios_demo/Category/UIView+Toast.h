//
//  UIView+Toast.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Toast)

- (void)showToastWithMessage:(NSString *)message duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
