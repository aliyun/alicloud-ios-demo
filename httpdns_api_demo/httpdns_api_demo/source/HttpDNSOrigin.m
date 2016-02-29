//
//  HttpDNSOrigin.m
//  httpdns_api_demo
//
//  Created by nanpo.yhl on 15/10/29.
//  Copyright © 2015年 com.aliyun.mobile. All rights reserved.
//

#import "HttpDNSOrigin.h"

@implementation HttpDNSOrigin

-(id)initWithHost:(NSString*)host
{
    if (self = [super init]) {
        _host = host;
    }
    return self;
}


-(BOOL)isExpired
{
    return _query + _ttl < [[NSDate date] timeIntervalSince1970];
}

-(NSString*)getIp
{
    return _ips ? [_ips objectAtIndex:0] : nil;
}


-(NSArray*)getIps
{
    return _ips;
}
@end
