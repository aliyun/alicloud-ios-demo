//
//  CustomToastUtil.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/21.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomToastUtil : NSObject

+ (void)showToastWithMessage:(NSString *)message isSuccess:(BOOL)success;

@end

NS_ASSUME_NONNULL_END
