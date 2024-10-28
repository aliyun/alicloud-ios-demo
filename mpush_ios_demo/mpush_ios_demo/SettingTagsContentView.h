//
//  SettingTagsContentView.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/24.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingTag.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DeleteTagHandle)(SettingTag *tag);

typedef void(^ContentViewShowAllTagsHandle)(void);

@interface SettingTagsContentView : UIView

@property (nonatomic, copy)DeleteTagHandle deleteHandle;
@property (nonatomic, copy)ContentViewShowAllTagsHandle showAllHandle;

- (instancetype)initWithTitle:(NSString *)title Tags:(NSArray<SettingTag *> *)tags;

- (CGFloat)getContentViewHeight;

- (void)hiddenLine;

@end

NS_ASSUME_NONNULL_END
