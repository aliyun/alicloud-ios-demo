//
//  EventCallback.h
//  WQConnector
//
//  Created by qinghua.liqh on 14-2-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCCall.h"

#define WQEventCallback BCEventCallback

@class WQHandlerResult;

typedef void (^WQEventCallbackBlock)(WQHandlerResult *result);

//Handler Callback协议
@protocol WQEventCallback <NSObject>
- (void) onResultCallForEvent:(NSString *)event path:(NSString *)path params:(NSDictionary *)params result:(WQHandlerResult *)result;
@end

@interface WQEventCallback : WQCall
@property (strong, nonatomic) id<WQEventCallback> callback;
@property (strong, nonatomic) WQEventCallbackBlock callbackBlock;
@end
