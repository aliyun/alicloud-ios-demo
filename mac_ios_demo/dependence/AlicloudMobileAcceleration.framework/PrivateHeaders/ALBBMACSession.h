//
//  ALBBMACSocket.h
//  ALINetworkSDK
//
//  Created by nanpo.yhl on 15-3-7.
//  Copyright (c) 2015年 nanpo.yhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBBMACTool.h"

#import "NAL_session.h"

@class ALBBMACOrigin;
@class ALBBMACHostSessionMgr;
@class ALBBMACRequest;
@class ALBBMACTraceString;

typedef enum {
    SC_INIT = 0,    // 对象new出来,还没初始化
    SC_CONNECTING,  // 发送connect指令出去
    SC_CONNECTED,   // 已经连上
    SC_VALID,       // 3次握手以后，gettimestamp接口验证过通路的可靠性
    SC_CLOSED_1,    // 上层主动关闭,等待TNETclose回调
    SC_CLOSED       // TNET回调close
}SessionStatus;

@interface ALBBMACSession : NSObject

@property(nonatomic,readonly)ALBBMACOrigin* origin;
@property(nonatomic,weak)ALBBMACHostSessionMgr* hostSessionMgr;
@property(nonatomic,readonly)NSString *domain;
@property(nonatomic,readonly)ALBBMACTraceString *trace;

-(id)initWithOrigin:(ALBBMACOrigin*)origin hostSessionMgr:(ALBBMACHostSessionMgr*)hostSessionMgr style:(SessionStyle)style;

/*
 * 设置conn的连接超时时间
 */
-(void)setConntimes:(int32_t)timeout;

/*
 * 设置重试次数
 */
-(void)setRetrytimes:(int32_t)retry_times;

/*
 * 是否需要长链，心跳时长
 */
-(void)keeplived:(int32_t)idle longChain:(BOOL)longChain;

/*
 * 查看当前session是否已经可用
 */
-(BOOL)valid;

/*
 * 异步建立tcp链接,发送connect指令,更新session状态
 */
-(void)asynConnect;

/*
 * 连接建立成功回调
 */
-(void)onConnect;

/*
 * 上层调用的disconnect,reason可不填
 */
-(void)disConnect;

/*
 * TNET里面回调上层建联失败
 * retry 是第几次尝试失败
 */
-(void)connFail:(int)retry error:(NSError*)error;

/*
 * TNET回调close
 */
-(void)close:(NSError*)error;

/*
 * 当前session 获取timestamp的接口成功
 */
-(void)onMonitor:(BOOL)success;

/*
 * 发送Ping帧
 */
-(void)sendPing;

/*
 * 收到Ping回调
 */
-(void)recvPingReply:(BOOL)flags;

/*
 * tcp 连接idle回调
 */
-(BOOL)idle;

/*
 * 获取idle时间值
 */
-(int)idleValue;

/*
 * 发送一个Http请求
 */
-(void)sendRequest:(ALBBMACRequest*)request;

/*
 * 在指定的request上面发送post数据
 */
-(void)sendData:(ALBBMACRequest*)request;

/*
 * 打点数据回调
 */
-(void)dataCollection:(NAL_connection_count_t*)count_ptr;

/*
 * 获取打点数据
 */
-(NSDictionary *)getConnData;
@end
