//
//  TDSService.h
//  TestTDS
//
//  Created by 郭天 on 15/5/12.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import "FederationToken.h"
#import "TDSArgs.h"

@protocol TDSService <NSObject>

- (FederationToken *)distributeToken:(TDSServiceType)serviceType;
- (NSString *)getAppid;

@end
