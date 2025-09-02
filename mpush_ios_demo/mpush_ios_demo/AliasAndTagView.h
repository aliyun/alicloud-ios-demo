//
//  AliasAndTagView.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/22.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ViewType) {
    ViewTypeAddAlias,
    ViewTypeAddTag,
    ViewTypeAliasAndTag,
};

typedef void(^AddAliasAndTagHandle)(void);

typedef void(^DeleteHandle)(NSString *content);

typedef void(^DeleteAliasTagHandle)(NSString *alias, NSString *tag);

@interface AliasAndTagView : UIView

@property (nonatomic, copy) AddAliasAndTagHandle addHandle;

@property (nonatomic, copy) DeleteHandle deleteHandle;

@property (nonatomic, copy) DeleteAliasTagHandle deleteAliasTagHandle;

@property (nonatomic, copy) NSString *alias;

- (instancetype)initWithType:(ViewType)type title:(nullable NSString *)title;

@end

NS_ASSUME_NONNULL_END
