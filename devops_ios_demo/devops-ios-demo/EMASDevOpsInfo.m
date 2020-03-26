//
//  EMASDevOpsInfo.m
//  devops-ios-demo
//
//  Created by 魏晓堃 on 2019/12/12.
//  Copyright © 2019 魏晓堃. All rights reserved.
//

#import "EMASDevOpsInfo.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>


static EMASDevOpsInfo *instance = nil;

@implementation EMASDevOpsInfo

+ (EMASDevOpsInfo *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[EMASDevOpsInfo alloc] init];
    });
    return instance;
}

- (NSString *)ip {
    return @"";
}

- (NSString *)proxyIp {
    return @"";
}

- (NSString *)ttid {
    return @"";
}

- (NSString *)identifier {
    if (!_identifier) {
        _identifier = @"xxx@iphoneos";
    }
    return _identifier;
}

- (NSString *)utdid {
    return @"";
}

- (NSString *)brand {
    return @"Apple";
}

- (NSString *)model {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return model;
}

- (NSString *)os {
    return [UIDevice currentDevice].systemName;
}

- (NSString *)osVersion {
    return [UIDevice currentDevice].systemVersion;
}

- (NSString *)appVersion {
    NSDictionary *appinfo = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [appinfo objectForKey:@"CFBundleShortVersionString"];
    if (!version) {
        version = @"10.0.0";
    }
    return version;
}

- (NSString *)apiLevel {
    return @"";
}

- (NSString *)arch {
    return @"";
}

- (NSString *)netStatus {
    return @"";
}

- (NSString *)locale {
    return @"";
}

- (NSString *)md5Sum {
    return @"";
}


- (NSDictionary *)converToParmaters {
    NSDictionary *dictionary = @{@"ip" : self.ip,
                                 @"proxyIp" : self.proxyIp,
                                 @"ttid" : self.ttid,
                                 @"identifier" : self.identifier,
                                 @"utdid" : self.utdid,
                                 @"brand" : self.brand,
                                 @"model" : self.model,
                                 @"os" : self.os,
                                 @"osVersion" : self.osVersion,
                                 @"apiLevel" : self.apiLevel,
                                 @"appVersion" : self.appVersion,
                                 @"arch" : self.arch,
                                 @"netStatus" : self.netStatus,
                                 @"locale" : self.locale,
                                 @"md5Sum" : self.md5Sum};
    return dictionary;;
}




@end
