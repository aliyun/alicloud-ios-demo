//
//  HTTPSScene.h
//  httpdns_ios_demo
//
//  Created by chenyilong on 12/9/2017.
//  Copyright © 2017 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPSScene : NSObject

- (void)httpDnsQueryWithURL:(NSString *)originalUrl completionHandler:(void(^)(NSString * message))completionHandler;

@end
