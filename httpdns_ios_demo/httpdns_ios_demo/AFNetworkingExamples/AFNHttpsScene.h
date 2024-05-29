//
//  AFNHttpsScene.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/5/27.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFNHttpsScene : NSObject

- (void)beginQuery:(NSString *)originalUrl completionHandler:(void(^)(NSString * ip, NSString * text))completionHandler;

@end

NS_ASSUME_NONNULL_END
