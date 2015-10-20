//
//  TDSClient.h
//  TDS-IOS-SDK
//
//  Created by 郭天 on 15/5/18.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FederationToken.h"
#import "TDSArgs.h"

@interface TDSClient : NSObject

+ (TDSClient*)sharedInstance;
- (FederationToken *)getFederationToken:(TDSServiceType)serviceType;
- (NSString *)getAppid;
@end
