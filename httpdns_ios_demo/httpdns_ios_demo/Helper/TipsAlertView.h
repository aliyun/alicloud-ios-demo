//
//  TipsAlertView.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TipsAlertView : UIView

+ (void)alertShow:(NSString *)title message:(NSString *)message domain:(NSString *)domain;

@end

NS_ASSUME_NONNULL_END
