//
//  TDSArgs.h
//  TestTDS
//
//  Created by 郭天 on 15/5/12.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    CAS_TOKEN,
    HTTPDNS_TOKEN,
    OSS_TOKEN
} TDSServiceType;

extern int const expireBeforeExpiration;

@interface TDSArgs : NSObject

@end
