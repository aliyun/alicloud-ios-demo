//
//  ALBBMACRequest.h
//  ALINetworkSDK
//
//  Created by nanpo.yhl on 15-3-7.
//  Copyright (c) 2015年 nanpo.yhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NAL_tools.h"
#import "NAL_request.h"

@class ALBBMACHostSessionMgr;
@class ALBBMACSession;
@class ALBBMACProtocol;

@interface ALBBMACRequest : NSObject

/*
 * 指定的mgr管理容器
 */
@property(nonatomic,weak)ALBBMACHostSessionMgr* hostSessionMgr;

/*
 * NSURLProtocol 获取到的原始request，不改变其原始的生命周期，weak引用
 */
@property(nonatomic,weak)NSURLRequest* originRequest;


/*
 * 保存回调时需要的接口,指定的回调client
 */
@property(nonatomic,weak)id<NSURLProtocolClient> client;


/*
 * 保存NSURLProtocol对象，用于回调
 */
@property(nonatomic,weak)ALBBMACProtocol* protocol;


/*
 * 标记当前request，是否取消
 */
@property(nonatomic,assign)BOOL cancel;


/*
 * 标记当前请求是否是timestamp接口，接口不一样回调的路径不一样
 */
@property(nonatomic,assign)BOOL isTimeStamp;

/*
 * 标记当前request，本地是否已经发送完成
 */
@property(nonatomic,assign)BOOL clientClosed;


/*
 * 对应到TNet中，使用的nalRequest
 */
@property(nonatomic)NAL_request_t* nalRequest;   // TNET 真是request


/*
 * tcp连接
 */
@property(nonatomic,strong)ALBBMACSession* session; // 固定send的session


/*
 * @request
 * @protocol
 * @args 一个鸡肋的参数，用于存储header头里面key/value
 */
- (id)initWithURLRequest:(NSURLRequest*)request
                protocol:(ALBBMACProtocol*)protocol
          hostSessionMgr:(ALBBMACHostSessionMgr*)hostSessionMgr
                    args:(NSDictionary*)args;

/*
 * 回调数据以及错误
 */
- (void)didReceiveResponse:(NSMutableDictionary*)httpHeader
            withStatusCode:(NSInteger)statusCode;

/*
 *  data部分数据处理
 */
- (void)didLoadData:(NSData*)data;

/*
 * request结束处理
 */
- (void)didLoadFinish;

/*
 * 出现错误的时候处理
 */
- (void)didLoadWithError:(NSError*)error call:(BOOL)call;

/*
 * 统计数据
 */
- (void)dataCollect:(NAL_request_count_t*)count_ptr;

/*
 * 取消请求
 */
- (void)cancelRequest;

/*
 * 处理data InpustStream时候
 */
- (bool)hasDataPending;


-(bool)hasDataAvailable;


-(NSData*)readData;
@end
