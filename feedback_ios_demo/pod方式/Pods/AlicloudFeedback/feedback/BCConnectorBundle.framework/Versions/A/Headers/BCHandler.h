//
//  Handler.h
//  WQConnector
//
//  Created by   on 14-2-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCCall.h"
#import "BCPermission.h"
#import "BCHandlerResult.h"

#define WQHandler BCHandler

//通过Handler返回的数据统一放到NSDictionary中.
//必须符合一定的规范
// 1. 所有key-value 都是 string -> string类型.

//返回, 需要retBlock, result
#define CALLRETBLOCK_AND_RETURN()             {if(retBlock != nil) { retBlock(result); } return;}

//成功返回, 需要retBlock
#define CALLRETBLOCK_AND_RETURN_SUCCESS(data) {if(retBlock != nil) { retBlock([WQHandlerResult resultFromCode:WQHandlerResultCodeOK result:data]); } return;}

//错误返回, 需要retBlock
#define CALLRETBLOCK_AND_RETURN_FAIL(data)    {if(retBlock != nil) { retBlock([WQHandlerResult resultFromCode:WQHandlerResultCodeError result:data]); } return;}
#define CALLRETBLOCK_AND_RETURN_CANCEL(data)    {if(retBlock != nil) { retBlock([WQHandlerResult resultFromCode:WQHandlerResultCodeCancel result:data]); } return;}

//返回，指定返回码，strCode，和data
#define CALLRETBLOCK(code, data, str)  {if(retBlock != nil){ retBlock([WQHandlerResult resultFromCode:code result:data strCode:str]);}return;}


//Handler Block
typedef void (^WQHandlerReturnBlock)(WQHandlerResult *result);
typedef WQHandlerResult* (^WQSyncHandlerBlock)(NSString *event, NSString *path, NSDictionary *params, NSDictionary* extraParams);
typedef void (^WQAsyncHandlerBlock)(NSString *event, NSString *path, NSDictionary *params, NSDictionary* extraParams, WQHandlerReturnBlock retBlock);

//Handler Callback协议
@protocol WQHandlerCallback <NSObject>
- (void) onHandlerCallForEvent:(NSString *)event path:(NSString *)path params:(NSDictionary *)params extraParams:(NSDictionary*)extraParams returnBlock:(WQHandlerReturnBlock)retBlock;
@end

@interface WQHandler : WQCall
@property (strong, nonatomic) id<WQHandlerCallback> callback;               //
@property (strong, nonatomic) WQSyncHandlerBlock syncCallbackBlock;         //同步处理Callback Block
@property (strong, nonatomic) WQAsyncHandlerBlock asyncCallbackBlock;       //异步处理Callback Block
@property (strong, nonatomic) WQPermission *eventPermission;                //权限
@property (strong, nonatomic) NSString *handlerEvent;                       //处理的Event
@property (strong, nonatomic) NSString *bindAppKey;                         //绑定的AppKey
@property (assign, nonatomic) BOOL shouldOpenUI;                            //是否需要打开UI

- (id)initWithEvent:(NSString *)event;
- (id)initWithEvent:(NSString *)event shouldOpenUI:(BOOL)shouldOpenUI;
- (id)initWithEvent:(NSString *)event withCallback:(id<WQHandlerCallback>)callback
        withContext:(NSDictionary *)context needRunInMainThread:(BOOL)mainThread shouldOpenUI:(BOOL)shouldOpenUI;
- (id)initWithEvent:(NSString *)event withSyncBlock:(WQSyncHandlerBlock)block needRunInMainThread:(BOOL)mainThread shouldOpenUI:(BOOL)shouldOpenUI;
- (id)initWithEvent:(NSString *)event withAsyncBlock:(WQAsyncHandlerBlock)block needRunInMainThread:(BOOL)mainThread shouldOpenUI:(BOOL)shouldOpenUI;

//判断是否能处理该Event，提供二次Check能力
- (BOOL)enable;

- (void)onAddedToConnector;
- (void)onRemovedFromConnector;
@end

