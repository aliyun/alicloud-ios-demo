//
//  CommonTools.h
//  mpush_ios_demo
//
//  Created by Miracle on 2025/5/13.
//  Copyright © 2025 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonTools : NSObject

+ (void)userDefaultSetObject:(id)value forKey:(NSString *)key;

+ (id)userDefaultGet:(NSString *)key;

+ (BOOL)textFiledIsEmpty:(UITextField *)textFiled;

+ (BOOL)stringIsEmpty:(NSString *)string;

+ (void)showTitle:(NSString *)title message:(NSString *)message handle:(void (^ __nullable)(UIAlertAction *action))handler;

+ (BOOL)getConfigViewVisible;

+ (NSDictionary *)getPreServiceUrl;

@end

NS_ASSUME_NONNULL_END
