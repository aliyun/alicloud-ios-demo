//
//  AliasListViewController.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/30.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChooseAliasHandle)(NSString *alias);

@interface AliasListViewController : UIViewController

@property (nonatomic, copy) NSArray *aliasArray;

@property (nonatomic, copy) ChooseAliasHandle chooseHandle;

@end

NS_ASSUME_NONNULL_END
