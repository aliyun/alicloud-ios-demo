//
//  YWFeedbackViewController.h
//  YWFeedbackKit
//
//  Created by 慕桥(黄玉坤) on 15/12/22.
//  Copyright © 2015年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YWFeedbackViewController BCFeedbackViewController

@class BCHybridWebView;
@class YWFeedbackViewController;
@class BCFeedbackKit;

/// @brief 关闭YWFeedbackView的block
typedef void (^ YWCloseBlock) (YWFeedbackViewController *feedbackController);

@interface YWFeedbackViewController : UIViewController
/// @brief 聊天界面Web容器
@property (nonatomic, strong, readonly) BCHybridWebView *contentView;

/// @brief 业务方扩展反馈数据
@property (nonatomic, strong, readonly) NSDictionary *extInfo;

/// @brief 关闭YWFeedbackView的block
@property (nonatomic,   copy) YWCloseBlock closeBlock;

- (instancetype)initWithFeedbackKit:(BCFeedbackKit *)feedbackKit
                            extInfo:(NSDictionary *)extInfo
                       configration:(NSDictionary *)configration;

#pragma mark 以下方法已被废弃，请勿使用
- (id)init NS_UNAVAILABLE;
- (id)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
/// @brief 此方法已被废弃，请使用initWithFeedbackKit:extInfo:configration:方法。
- (id)initWithChatInfo:(NSDictionary *)chatInfo
         customUIPlist:(NSDictionary *)customUIPlist
               extInfo:(NSDictionary *)extInfo NS_UNAVAILABLE;
@end
