//
//  SettingDomainListTableViewCell.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CheckBoxHandle)(BOOL isSelected);

@interface SettingDomainListTableViewCell : UITableViewCell

@property(nonatomic, copy)CheckBoxHandle selecetedHandle;

- (void)setDomain:(NSString *)domain isSelected:(BOOL)isSelected;

- (void)checkBoxClick;

@end

NS_ASSUME_NONNULL_END
