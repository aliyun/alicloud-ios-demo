//
//  NetworkManager.m
//  httpdns_ios_demo
//
//  Created by ryan on 27/1/2016.
//  Copyright © 2016 alibaba. All rights reserved.
//

#import "NetworkManager.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <UIKit/UIDevice.h>

static char *const networkManagerQueue = "com.alibaba.managerQueue";
static dispatch_queue_t reachabilityQueue;

@implementation NetworkManager
{
    _NetworkStatus _current;
    _NetworkStatus _last;
    SCNetworkReachabilityRef _ref;
    NSString *_ssid;
    CTTelephonyNetworkInfo *_cttInfo;
}

- (id)init {
    if (self = [super init]) {
        _ref = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [@"gw.alicdn.com" UTF8String]);
        _cttInfo = [[CTTelephonyNetworkInfo alloc] init];
        
        [self update];
        [self startNotify];
    }
    
    return self;
}

+ (NetworkManager *)instance {
    static NetworkManager *_instance = nil;
    @synchronized(self) {
        _instance = [[NetworkManager alloc] init];
    }
    return _instance;
}


/*
 * 当前网络状态的String描述
 */
- (NSString *)currentStatusString
{
    return [NSString stringWithFormat:@"%u", _current];
}

/*
 * 如果当前网络是Wifi,
 * 获取到当前网络的ssid
 */
- (NSString *)currentWifiSsid
{
    return _ssid;
}

- (_NetworkStatus)reachabilityFlags:(SCNetworkReachabilityFlags)flags
{
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0 || ![self internetConnection]) {
        // The target host is not reachable.
        return NotReachable;
    }
    
    _NetworkStatus returnValue = NotReachable;
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        returnValue = ReachableViaWiFi;
    }
    
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
            returnValue = ReachableViaWiFi;
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
        returnValue = ReachableVia4G;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
        if ((flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable) {
            if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection) {
                returnValue = ReachableVia3G;
                
                if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired) {
                    returnValue = ReachableVia2G;
                }
            }
        }
    }
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version >= 7.0f && returnValue != ReachableViaWiFi) {
        NSString *nettype = _cttInfo.currentRadioAccessTechnology;
        if (nettype) {
            if ([CTRadioAccessTechnologyGPRS isEqualToString:nettype]) {
                return ReachableVia2G;
            } else if ([CTRadioAccessTechnologyLTE isEqualToString:nettype] || [CTRadioAccessTechnologyeHRPD isEqualToString:nettype]) {
                return ReachableVia4G;
            }
        }
    }
    
    return returnValue;
}

- (void)update {
    SCNetworkReachabilityFlags flags = 0;
    if (SCNetworkReachabilityGetFlags(_ref, &flags)) {
        _last = _current;
        _current = [self reachabilityFlags:flags];
        
        // change bssid
        if (_current == ReachableViaWiFi) {
            NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
            for (NSString *ifnam in ifs) {
                id info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam));
                NSString *bssidValue = [info objectForKey:(NSString *)kCNNetworkInfoKeyBSSID];
                NSString *ssidValue = [info objectForKey:(NSString *)kCNNetworkInfoKeySSID];
                if (bssidValue.length <= 0) {
                    continue;
                }
                _ssid = [NSString stringWithFormat:@"%@-%@", ssidValue, bssidValue];
            }
        }
    }
}

// 网络变化回调函数
static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info)
{
    NetworkManager *instance = [NetworkManager instance];
    [instance update];
}

- (void)startNotify {
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    if (SCNetworkReachabilitySetCallback(_ref, ReachabilityCallback, &context)) {
        reachabilityQueue = dispatch_queue_create(networkManagerQueue, DISPATCH_QUEUE_SERIAL);
        SCNetworkReachabilitySetDispatchQueue(_ref, reachabilityQueue);
    }
}

- (BOOL)internetConnection
{
    struct sockaddr_in zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    return (isReachable && !needsConnection) ? YES : NO;
}


+ (BOOL) configureProxies
{
    NSDictionary *proxySettings = CFBridgingRelease(CFNetworkCopySystemProxySettings());
    
    NSArray *proxies = nil;
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://api.m.taobao.com"];
    
    proxies = CFBridgingRelease(CFNetworkCopyProxiesForURL((__bridge CFURLRef)url,
                                                           (__bridge CFDictionaryRef)proxySettings));
    if (proxies.count > 0)
    {
        NSDictionary *settings = [proxies objectAtIndex:0];
        NSString *host = [settings objectForKey:(NSString *)kCFProxyHostNameKey];
        NSString *port = [settings objectForKey:(NSString *)kCFProxyPortNumberKey];
        
        if (host || port)
        {
            return YES;
        }
    }
    return NO;
}

@end
