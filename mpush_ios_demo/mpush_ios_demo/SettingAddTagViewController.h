//
//  SettingAddTagViewController.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/28.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingTag.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AddTagResultHandle)(SettingTag *tag);

@interface SettingAddTagViewController : UIViewController

@property (nonatomic, copy)NSArray *aliasArray;

@property (nonatomic, copy)AddTagResultHandle addHandle;

@end

NS_ASSUME_NONNULL_END
