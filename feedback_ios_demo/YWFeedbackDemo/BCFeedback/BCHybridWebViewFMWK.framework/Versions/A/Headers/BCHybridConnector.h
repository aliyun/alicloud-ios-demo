//
//  BridgeConnector.h
//  WQOpenSDK
//
//  Created by qinghua.liqh on 14-3-15.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BCConnectorBundle/BCConnector.h>

#define YWHybridConnector BCHybridConnector

typedef void(^YWHybridHandleBlock)(NSString *event, NSString *path, NSDictionary *params, NSDictionary *extraParams, WQHandlerReturnBlock retBlock);

//实现上不从
@interface YWHybridConnector : NSObject


- (id)initWithAppKey:(NSString *)appKey;

- (void)registerEventHandler:(WQHandler *)handler;
- (void)registerBridgeEvent:(NSString *)event handler:(YWHybridHandleBlock)handler;
//通过selector注册
- (void)registerBridgeEvent:(NSString *)event target:(id)target selector:(SEL)selector;
- (void)unregisterBridgeEvent:(NSString *)event;
- (void)unregisterAll;
- (NSArray *)getRegisteredEvents;
- (BOOL)hasRegesteredEvent:(NSString *)event;

- (void)registerBridgeModule:(NSString *)module andMethod:(NSString *)method handler:(YWHybridHandleBlock)handler;
- (void)unregisterBridgeModule:(NSString *)event andMethod:(NSString *)method;

//对接到其它Event上
- (void)mapEventFrom:(NSString *)fromEvent toEvent:(NSString *)toEvent;


-(WQConnectCode)sendEventRequest:(NSString *)event
                          params:(NSDictionary *)params
                   callBackBlock:(WQEventCallbackBlock)callback;

-(WQConnectCode)sendEventRequest:(NSString *)event
                          params:(NSDictionary *)params
                   callBackBlock:(WQEventCallbackBlock)callback
                    extraParams:(NSDictionary *)extraParams;
@end
