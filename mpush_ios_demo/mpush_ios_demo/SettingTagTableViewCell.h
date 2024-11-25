//
//  SettingTagTableViewCell.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/23.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingTag.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AddTagHandle)(void);

typedef void(^DeleteTagHandle)(SettingTag *tag);

typedef void(^ShowAllTagsHandle)(int tagType);

@interface SettingTagTableViewCell : UITableViewCell

@property (nonatomic, copy)AddTagHandle addHandle;

@property (nonatomic, copy)DeleteTagHandle deleteHandle;

@property (nonatomic, copy)ShowAllTagsHandle showAllHandle;

- (void)setTagsData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
