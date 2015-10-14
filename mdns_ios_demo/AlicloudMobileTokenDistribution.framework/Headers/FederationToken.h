//
//  FederationToken.h
//  TestTDS
//
//  Created by 郭天 on 15/5/12.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FederationToken : NSObject

@property (nonatomic, strong) NSString *requestId;
@property (nonatomic, strong) NSString *serviceType;
@property (nonatomic, strong) NSString *federatedUser;
@property (nonatomic, strong) NSString *accessKeyId;
@property (nonatomic, strong) NSString *accessKeySecret;
@property (nonatomic, strong) NSString *securityToken;
@property (nonatomic) long expiration;
@property (nonatomic) long long localExpiration;
@property (nonatomic) long long remainingTimeSec;
@property (nonatomic) BOOL fired;

@end
