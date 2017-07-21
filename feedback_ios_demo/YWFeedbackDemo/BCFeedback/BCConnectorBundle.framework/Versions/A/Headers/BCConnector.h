//
//  BCConnector.h
//  WQConnector
//
//  Created by qinghua.liqh on 14-2-20.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _WQConnectCode {
    WQConnectOK             = 0,
    WQConnectNOHandler      = 1,
    WQConnectNOPermission   = 2,
    WQConnectArgError       = 3,
}WQConnectCode;


#import "BCHandler.h"
#import "BCEventCallback.h"
#import "BCConstants.h"
#import "BCEAppClient.h"
#import "BCCommand.h"

#define WQConnector BCConnector

@class WQEAppClient;

/* 
 *  getGlobalConnector 获取通用无权限, EApp无关的Connector,
 *  getClientConnector 获取旺企客户端关联的Connnector, 关联biz_token权限
 *  getWQConnectorByAppKey 获取EApp关联的的Connector, 关联到EApp对用的access_token
 */
@interface WQConnector : NSObject
- (id)initWithParentConnector:(WQConnector *)parentConnector andClient:(WQEAppClient *)client;;

//设置客户端信息
+ (void)setClientAppKey:(NSString *)appKey appSecret:(NSString *)appSecret appCallback:(NSString *)callback;

+ (id)registerWQConnector:(NSString *)appKey client:(WQEAppClient *)client withParentConnector:(WQConnector *)parentConnector;
+ (WQConnector *)getWQConnectorByAppKey:(NSString *)appKey;
//获取当前客户端的Connector, 同global差异是global没有任何权限控制, 只能处理通过registerGlobalEventHandler添加的event.
+ (WQConnector *)getClientConnector;
+ (WQConnector *)getGlobalConnector;

//移除所有非global WQConnector， 主要在账户切换时调用
+ (void)reset;

//注册全局Handler
+ (void)registerGlobalEventHandler:(WQHandler *)handler;
+ (void)registerGlobalDefaultEventHandler:(WQHandler *)handler;

//注册和反注册实例Handler
- (void)registerEventHandler:(WQHandler *)handler;
- (void)registerDefaultEventHandler:(WQHandler *)handler;
- (void)unregisterEventHandler:(NSString *)event;
- (void)unregisterAll;

//是否能处理event(会判断到scheme层面)
- (BOOL)canHandleEvent:(NSString *)event canOpenUI:(BOOL)canOpenUI;
//直接判断是否能处理event, 
- (BOOL)canHandleEventDirectly:(NSString *)event canOpenUI:(BOOL)canOpenUI;
- (NSString *)getAppKey;

- (NSArray *)getRegisteredEvents;


#pragma mark - 通用接口
//发送event请求
//JSSDK接口可以直接对接到该函数调用
- (WQConnectCode)sendEventRequest:(NSString *)event
                            path:(NSString *)path
                          params:(NSDictionary *)params
                   eventCallback:(WQEventCallback *)callback
                      extraParams:(NSDictionary *)extraParams;

//发送event请求, block参数方便调用.
- (WQConnectCode)sendEventRequest:(NSString *)event
                            path:(NSString *)path
                          params:(NSDictionary *)params
                   callBackBlock:(WQEventCallbackBlock)callback
                      extraParams:(NSDictionary *)extraParams;

//发送Command
- (WQConnectCode)sendEventRequestCmd:(WQCommand *)cmd;

//对接到其它Event上
- (void)mapEventFrom:(NSString *)fromEvent toEvent:(NSString *)toEvent;
@end
