//
//  TagsCollectionViewCell.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/11/1.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingTag.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DeleteHandle)(SettingTag *tag);
typedef void(^DeleteAliasHandle)(NSString *alias);

@interface TagsCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) DeleteHandle deleteHandle;

@property (nonatomic, copy) DeleteAliasHandle deleteAliasHandle;

- (void)setTag:(SettingTag *)tag;

- (void)setAlias:(NSString *)alias;

@end

NS_ASSUME_NONNULL_END
