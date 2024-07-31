//
//  SettingOtherTableViewCell.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, OtherCellType) {
    HelpCenterCell,
    AboutUsCell,
    DefaultSettingCell,
};

@interface SettingOtherTableViewCell : UITableViewCell

- (void)setCellType:(OtherCellType)cellType;

@end

NS_ASSUME_NONNULL_END
