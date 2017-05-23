//
//  ProxyHandler.h
//  WQConnector
//
//  Created by qinghua.liqh on 14-2-23.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCHandler.h"

#define WQProxyHandler BCProxyHandler

@interface WQProxyHandler : WQHandler
@property (strong, nonatomic) NSString *handlerAppkey;
@property (strong, nonatomic) NSString *handlerCallbackUrl;

@end
