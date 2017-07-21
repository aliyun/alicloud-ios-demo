//
//  YWFeedbackKit.h
//  YWFeedbackKit
//
//  Created by 慕桥(黄玉坤) on 15/12/21.
//  Copyright © 2015年 alibaba. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import "YWFeedbackViewController.h"
#define YWFeedbackKit BCFeedbackKit

typedef NS_ENUM(NSInteger, YWFeedbackKitErrorCode)
{
    //AppKey/AppSecret错误
    YW_APPKEY_ERROR   = 1001,
    //获取配置文件错误
    YW_CONFIG_ERROR   = 1002,
    //获取未读数错误
    YW_UNREAD_ERROR   = 1003,
    //拍照错误
    YW_CAMERA_ERROR   = 1004,
    //获取相册错误
    YW_ALBUM_ERROR    = 1005,
    //网络错误
    YW_NETWORK_ERROR  = 1006,
    //未知错误
    YW_UNKNOWN_ERROR  = 1100
};

@interface YWFeedbackKit : NSObject

/// @brief appKey
@property (nonatomic, copy) NSString *appKey;
/// @brief appSecret
@property (nonatomic, copy) NSString *appSecret;

/// @brief 业务方扩展反馈数据，在创建反馈页面前设置
@property (nonatomic, strong, readwrite) NSDictionary *extInfo;

/// @brief 如果不设置，默认为：`[UIFont boldSystemFontOfSize:13]`
@property (nonatomic, strong) UIFont *defaultCloseButtonTitleFont;

/// @brief 如果不设置，默认为：`[UIFont boldSystemFontOfSize:13]`
@property (nonatomic, strong) UIFont *defaultRightBarButtonItemTitleFont;

/// @brief 获取当前SDK版本号
+ (NSString *)version;

/// @brief 反馈页面对外抛出Error的回调block。不设置此属性时，将使用默认Alert方式进行错误提示
/// @params viewController 反馈页面
/// @return error 失败error
@property (nonatomic, copy) void (^YWFeedbackViewControllerErrorBlock) (YWFeedbackViewController *viewController, NSError *error);

/// @brief 初始化方法
/// @params anAppKey AppKey
/// @params anAppSecret AppSecret
/// @return YWFeedbackKit实例
- (instancetype)initWithAppKey:(NSString *)anAppKey appSecret:(NSString *)anAppSecret;

/// @brief 创建反馈页面回调Block
/// @params viewController 反馈页面
/// @return error 调用失败返回错误
typedef void (^YWMakeFeedbackViewControllerCompletionBlock) (YWFeedbackViewController * viewController, NSError *error);

/// @brief 创建反馈页面，默认为不显示弹出错误信息
- (void)makeFeedbackViewControllerWithCompletionBlock:(YWMakeFeedbackViewControllerCompletionBlock)completionBlock;

/// @brief 反馈未读消息数回调Block
/// @params unreadCount 未读消息数
/// @return error 调用失败返回错误
typedef void (^YWGetUnreadCountCompletionBlock) (NSInteger unreadCount, NSError *error);

/// @brief 请求反馈未读消息数
- (void)getUnreadCountWithCompletionBlock:(YWGetUnreadCountCompletionBlock)completionBlock;

#pragma mark 以下方法已被废弃，请勿使用
/// 此方法已被废弃，请使用`- (instancetype)initWithAppKey:(NSString *)anAppKey appSecret:(NSString *)appSecret;`
- (instancetype)initWithOpenIMUserId:(NSString *)aOpenIMUserId
                            password:(NSString *)aPassword
                              appKey:(NSString *)anAppKey NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

