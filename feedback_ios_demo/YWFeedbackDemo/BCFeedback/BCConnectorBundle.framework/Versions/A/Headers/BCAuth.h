//
//  BCAuth.h
//  WQConnector
//
//  Created by qinghua.liqh on 14-2-22.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WQAuth BCAuth

@interface WQAuth : NSObject
@property(copy,nonatomic) NSString *access_token;

-(id)initWQAuthFromString:(NSString*) authString;
-(NSString *)encodeWQAuthToJsonString;
@end
