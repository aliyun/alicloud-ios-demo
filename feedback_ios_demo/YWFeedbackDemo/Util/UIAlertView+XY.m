//
//  UIAlertView+XY.m
//  JoinShow
//
//  Created by Heaven on 13-10-17.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#undef	UIAlertView_key_clicked
#define UIAlertView_key_clicked	"UIAlertView.clicked"
#undef	UIAlertView_key_cancel
#define UIAlertView_key_cancel	"UIAlertView.cancel"
#undef	UIAlertView_key_willPresent
#define UIAlertView_key_willPresent	"UIAlertView.willPresent"
#undef	UIAlertView_key_didPresent
#define UIAlertView_key_didPresent	"UIAlertView.didPresent"
#undef	UIAlertView_key_willDismiss
#define UIAlertView_key_willDismiss	"UIAlertView.willDismiss"
#undef	UIAlertView_key_didDismiss
#define UIAlertView_key_didDismiss	"UIAlertView.didDismiss"
#undef	UIAlertView_key_shouldEnableFirstOtherButton
#define UIAlertView_key_shouldEnableFirstOtherButton	"UIAlertView.SEFOB"

#import "UIAlertView+XY.h"
#import <objc/runtime.h>

@implementation UIAlertView (XY)

- (void)handlerClickedButton:(UIAlertView_block_self_index)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_clicked, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)handlerCancel:(void (^)(UIAlertView *alertView))aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_cancel, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)handlerWillPresent:(void (^)(UIAlertView *alertView))aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_willPresent, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)handlerDidPresent:(void (^)(UIAlertView *alertView))aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_didPresent, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)handlerWillDismiss:(UIAlertView_block_self_index)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_willDismiss, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)handlerDidDismiss:(UIAlertView_block_self_index)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_didDismiss, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)handlerShouldEnableFirstOtherButton:(UIAlertView_block_shouldEnableFirstOtherButton)aBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, UIAlertView_key_shouldEnableFirstOtherButton, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertView_block_self_index block = objc_getAssociatedObject(self, UIAlertView_key_clicked);
    
    if (block)
        block(alertView, buttonIndex);
}
- (void)alertViewCancel:(UIAlertView *)alertView
{
    UIAlertView_block_self block = objc_getAssociatedObject(self, UIAlertView_key_cancel);
    
    if (block)
        block(alertView);
}
- (void)willPresentAlertView:(UIAlertView *)alertView{
    UIAlertView_block_self block = objc_getAssociatedObject(self, UIAlertView_key_willPresent);
    
    if (block)
        block(alertView);
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    UIAlertView_block_self block = objc_getAssociatedObject(self, UIAlertView_key_didPresent);
    
    if (block)
        block(alertView);
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIAlertView_block_self_index block = objc_getAssociatedObject(self, UIAlertView_key_willDismiss);
    
    if (block)
        block(alertView,buttonIndex);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIAlertView_block_self_index block = objc_getAssociatedObject(self, UIAlertView_key_didDismiss);
    
    if (block)
        block(alertView, buttonIndex);
}


- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UIAlertView_block_shouldEnableFirstOtherButton block = objc_getAssociatedObject(self, UIAlertView_key_shouldEnableFirstOtherButton);
    
    if (block)
        return block(alertView);

    return YES;
}

- (void)showWithDuration:(NSTimeInterval)i
{
    [NSTimer scheduledTimerWithTimeInterval:i
                                     target:self
                                   selector:@selector(xyDismiss)
                                   userInfo:self
                                    repeats:NO];
    [self show];
}

- (void)xyDismiss
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

@end
