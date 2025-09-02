//
//  SettingAliasTableViewCell.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/21.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AddAliasHandle)(void);

typedef void(^DeleteAliasHandle)(NSString *alias);

typedef void(^ShowAllAliasHandle)(void);

@interface SettingAliasTableViewCell : UITableViewCell

@property (nonatomic, copy) AddAliasHandle addHandle;

@property (nonatomic, copy) DeleteAliasHandle deleteHandle;

@property (nonatomic, copy) ShowAllAliasHandle showAllHandle;

- (void)setAlias:(NSArray *)aliasArray;

@end

NS_ASSUME_NONNULL_END
