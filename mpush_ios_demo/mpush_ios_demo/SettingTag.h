//
//  SettingTag.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/24.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingTag : NSObject

@property (nonatomic, assign) int tagId;

/// 标签名
@property (nonatomic, copy) NSString *tagName;

/// 标签绑定的别名
@property (nonatomic, copy) NSString *tagAlias;

/// 标签类型 1：本设备  2：本设备绑定账号  3：别名
@property (nonatomic, assign) int tagType;

@end

NS_ASSUME_NONNULL_END
