//
//  ALBBMASSecuritySDKRequestAuthentication.h
//  TestMAS
//
//  Created by 郭天 on 15/3/5.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UTMini/UTSecuritySDKRequestAuthentication.h>
//#import "UTSecuritySDKRequestAuthentication.h"

@interface ALBBMASSecuritySDKRequestAuthentication : UTSecuritySDKRequestAuthentication

-(id) initWithAppKey:(NSString *) pAppKey;

@end
