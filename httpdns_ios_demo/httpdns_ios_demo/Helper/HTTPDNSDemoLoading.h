//
//  HTTPDNSDemoLoading.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTTPDNSDemoLoading : UIView

+ (void)showLoading;
+ (void)stopLoading;

- (void)startLoading;
- (void)stopLoading;

@end

NS_ASSUME_NONNULL_END
