//
//  ALBBMASBaseRequestAuthentication.h
//  TestMAS
//
//  Created by 郭天 on 15/3/5.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UTMini/UTBaseRequestAuthentication.h>
//#import "UTBaseRequestAuthentication.h"
#import "ALBBMASIRequestAuthentication.h"

@interface ALBBMASBaseRequestAuthentication : UTBaseRequestAuthentication<ALBBMASIRequestAuthentication>

-(id) initWithAppKey:(NSString *) pAppKey appSecret:(NSString *) pSecret;

@end
