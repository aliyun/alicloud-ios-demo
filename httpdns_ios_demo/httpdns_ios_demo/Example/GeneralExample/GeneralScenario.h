//
//  GeneralScene.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/22.
//

#import <Foundation/Foundation.h>

@interface GeneralScenario : NSObject

+ (void)httpDnsQueryWithURL:(NSString *)originalUrl completionHandler:(void(^)(NSString * message))completionHandler;

@end
