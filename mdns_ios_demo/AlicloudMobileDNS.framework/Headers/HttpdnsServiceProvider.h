//
//  Dpa_Httpdns_iOS.h
//  Dpa-Httpdns-iOS
//
//  Created by zhouzhuo on 5/1/15.
//  Copyright (c) 2015 zhouzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpdnsModel.h"
#import "ALBBHttpdnsServiceProtocol.h"

@class HttpdnsRequestScheduler;

@interface HttpDnsServiceProvider: NSObject<ALBBHttpdnsServiceProtocol>

@property (nonatomic, strong) HttpdnsRequestScheduler *requestScheduler;
@property (nonatomic, strong, setter=setAppId:) NSString * appId;
@property (nonatomic, strong, setter=setCredentialProvider:) id<HttpdnsCredentialProvider> credentialProvider;

+(instancetype)getService;

@end
