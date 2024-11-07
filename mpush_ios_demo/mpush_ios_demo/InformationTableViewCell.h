//
//  InformationTableViewCell.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/11/1.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InformationTableViewCell : UITableViewCell

- (void)setTitle:(NSString *)title detail:(NSString *)detail;

- (void)showCopyButton;

- (void)hiddenCopyButton;

@end

NS_ASSUME_NONNULL_END
