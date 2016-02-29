//
//  HttpDNSLog.h
//  httpdns_api_demo
//
//  Created by nanpo.yhl on 15/10/30.
//  Copyright © 2015年 com.aliyun.mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpDNSLog : NSObject
+ (void)log:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (void)turnOnDebug;
@end
