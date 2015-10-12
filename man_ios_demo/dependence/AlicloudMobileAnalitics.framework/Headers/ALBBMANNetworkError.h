//
//  ALBBMANNetworkError.h
//  AlicloudMobileAnalitics
//
//  Created by nanpo.yhl on 15/10/9.
//  Copyright (c) 2015年 com.aliyun.tds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBBMANNetworkError : NSObject
@property(nonatomic,strong)NSMutableDictionary* properties;

+(ALBBMANNetworkError*) ErrorWithHttpException4;

+(ALBBMANNetworkError*) ErrorWithHttpException5;

+(ALBBMANNetworkError*) ErrorWithSocketTimeout;

+(ALBBMANNetworkError*) ErrorWithIOInterrupted;

-(id)initWithErrorCode:(NSString*)code;

-(void)setProperty:(NSString *)property value:(NSString *)value;

@end
