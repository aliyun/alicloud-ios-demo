//
//  CustomAlertView.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/16.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^InputHandle)(NSString *inputString);

typedef NS_ENUM(NSUInteger, AlertInputType) {
    AlertInputTypeBindAlias, // 绑定别名
    AlertInputTypeBindAccount, // 绑定账号
    AlertInputTypeSyncBadgeNum // 角标同步
};

@interface CustomAlertView : UIView

+ (void)showLimitNoteAlertView;

+ (void)showInputAlert:(AlertInputType)type handle:(InputHandle)handle;

@end

NS_ASSUME_NONNULL_END
