//
//  SettingTableViewCell.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/29.
//

#import <UIKit/UIKit.h>
#import "SettingBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, settingCellType) {
    RegionCell,
    TimeOutCell,
};

typedef void(^detailValueChangedHandle)(NSString *value);

@interface SettingTableViewCell : SettingBaseTableViewCell

@property(nonatomic, copy)detailValueChangedHandle valueChangedHandle;

- (void)setCellTitle:(NSString *)title description:(NSString *)description cellType:(settingCellType)cellType  detailValue:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
