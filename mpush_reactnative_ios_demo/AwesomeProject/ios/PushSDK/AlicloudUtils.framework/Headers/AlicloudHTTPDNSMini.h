//
//  AlicloudHTTPDNSMini.h
//  AlicloudUtils
//
//  Created by ryan on 3/6/2016.
//  Copyright © 2016 Ali. All rights reserved.
//

#ifndef AlicloudHTTPDNSMini_h
#define AlicloudHTTPDNSMini_h

#define HTTPDNSMINI_RESOLVED_NOTIFY @"HTTPDNSMiniResolvedNotify"

@interface AlicloudHTTPDNSMini : NSObject

+ (AlicloudHTTPDNSMini *)sharedInstance;
- (NSArray *)getIpsByHostAsync:(NSString *)host;
- (void)setPreResolveHosts:(NSArray *)hosts;

@end

#endif /* AlicloudHTTPDNSMini_h */
