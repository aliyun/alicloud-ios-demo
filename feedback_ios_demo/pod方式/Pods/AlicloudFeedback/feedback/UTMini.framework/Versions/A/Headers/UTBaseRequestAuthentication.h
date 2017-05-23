//
//  BaseRequestAuthentication.h
//  miniUTInterface
//
//  Created by 宋军 on 14-10-17.
//  Copyright (c) 2014年 ___SONGJUN___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTIRequestAuthentication.h"

@interface UTBaseRequestAuthentication : NSObject<UTIRequestAuthentication>

-(id) initWithAppKey:(NSString *) pAppKey appSecret:(NSString *) pSecret;

@end
