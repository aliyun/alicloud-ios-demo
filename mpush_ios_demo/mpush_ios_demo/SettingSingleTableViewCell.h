//
//  SettingSingleTableViewCell.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/21.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SettingSingleCellType) {
    SettingSingleCellTypeAccount,
    SettingSingleCellTypeBadgeNumber,
};

@interface SettingSingleTableViewCell : UITableViewCell

+ (instancetype)cellWithType:(SettingSingleCellType)cellType;

@end

NS_ASSUME_NONNULL_END
