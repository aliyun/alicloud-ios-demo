//
//  HttpDNSLog.m
//  httpdns_api_demo
//
//  Created by nanpo.yhl on 15/10/30.
//  Copyright © 2015年 com.aliyun.mobile. All rights reserved.
//

#import "HttpDNSLog.h"

static BOOL debug = NO;

@implementation HttpDNSLog
+(void)log:(NSString *)format, ...NS_FORMAT_FUNCTION(1,2)
{
    if (debug) {
        va_list args;
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        NSLog(@"[HttpDNS-DEBUG] %@", message);
    }
}

+ (void)turnOnDebug
{
    debug = YES;
}

@end
