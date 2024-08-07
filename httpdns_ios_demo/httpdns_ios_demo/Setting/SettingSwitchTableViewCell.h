//
//  SettingSwitchTableViewCell.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/25.
//

#import <UIKit/UIKit.h>
#import "SettingBaseTableViewCell.h"

typedef void(^switchChangedHandle)(BOOL isOn);

NS_ASSUME_NONNULL_BEGIN

@interface SettingSwitchTableViewCell : SettingBaseTableViewCell

@property(nonatomic, copy)switchChangedHandle switchChangedhandle;

- (void)setTitle:(NSString *)title description:(NSString *)description isOn:(BOOL)isOn;

@end

NS_ASSUME_NONNULL_END
