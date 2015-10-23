//
//  ALBBMACSession.h
//  ALINetworkSDK
//
//  Created by nanpo.yhl on 15-3-7.
//  Copyright (c) 2015年 nanpo.yhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALBBMACSession;
@class ALBBMACRequest;

@interface ALBBMACHostSessionMgr : NSObject

+(ALBBMACHostSessionMgr*)shareInstance;

/*
 * 开始尝试解析policy，尝试连接
 */
-(void)start;

/*
 * stop
 */
-(void)stop;

/*
 * 连接状态check
 */
-(BOOL)vaildSession;

/*
 * 连上的回调call
 */
-(void)onConnect:(ALBBMACSession*)session;

/*
 * 多次尝试以后依然失败
 */
-(void)onConnFail:(ALBBMACSession*)session error:(NSError*)error;

/*
 * 断开的回调
 */
-(void)close:(ALBBMACSession*)session error:(NSError*)error;

/*
 * 处理当前的connection，是否需要立刻放出,否则挂在watings上
 */
-(void)issueRequest:(ALBBMACRequest*)request;

/*
 * 删除指定的connection
 */
-(void)removeRequest:(ALBBMACRequest*)request;

@end
