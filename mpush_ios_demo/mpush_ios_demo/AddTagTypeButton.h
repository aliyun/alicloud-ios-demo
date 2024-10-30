//
//  AddTagTypeButton.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/30.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddTagTypeButton : UIButton

- (void)setName:(NSString *)name hasArrow:(BOOL)hasArrow;

- (void)setValue:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
