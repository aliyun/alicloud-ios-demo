//
//  UIAlertView+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-17.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^UIAlertView_block_self_index)(UIAlertView *alertView, NSInteger btnIndex);
typedef void(^UIAlertView_block_self)(UIAlertView *alertView);
typedef BOOL(^UIAlertView_block_shouldEnableFirstOtherButton)(UIAlertView *alertView);

@interface UIAlertView (XY)

- (void)handlerClickedButton:(UIAlertView_block_self_index)aBlock;
- (void)handlerCancel:(UIAlertView_block_self)aBlock;
- (void)handlerWillPresent:(UIAlertView_block_self)aBlock;
- (void)handlerDidPresent:(UIAlertView_block_self)aBlock;
- (void)handlerWillDismiss:(UIAlertView_block_self_index)aBlock;
- (void)handlerDidDismiss:(UIAlertView_block_self_index)aBlock;
- (void)handlerShouldEnableFirstOtherButton:(UIAlertView_block_shouldEnableFirstOtherButton)aBlock;

// 延时消失
- (void)showWithDuration:(NSTimeInterval)i;

@end
