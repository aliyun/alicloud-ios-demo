//
//  SDKStatusManager.h
//  mpush_ios_demo
//
//  Created by Miracle on 2025/8/1.
//  Copyright © 2025 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDKStatusManager : NSObject

/// 获取SDK是否初始化成功
+ (BOOL)getSDKInitStatus;

/// 更新SDK初始化状态
/// - Parameter isSuccess: 是否初始化成功
+ (void)updateSDKStatus:(BOOL)isSuccess;

@end

NS_ASSUME_NONNULL_END
