//
//  HttpdnsRequestScheduler.h
//  Dpa-Httpdns-iOS
//
//  Created by zhouzhuo on 5/1/15.
//  Copyright (c) 2015 zhouzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HttpdnsHostObject;

@interface HttpdnsRequestScheduler : NSObject

// 管理所有的Host对象，key为HostName
@property (nonatomic, strong) NSMutableDictionary *hostManagerDict;

// 查询队列，查询Host的任务会进入这个队列排队
@property (nonatomic, strong) NSMutableArray *lookupQueue;

// 同步队列，对hostManagerDict和requestQueue的操作都要dispatch到这个队列执行
@property (nonatomic, assign) dispatch_queue_t syncDispatchQueue;

// 异步队列
@property (nonatomic, assign) dispatch_queue_t asyncDispatchQueue;

// 异步队列，涉及网络操作的任务dispatch到这个队列执行
@property (nonatomic, strong) NSOperationQueue *asyncOperationQueue;

// 一个新的单个域名查询到来时，等待一秒钟看看随后有没有别的查询可以合并
@property (nonatomic, strong) NSTimer *timer;



// 每次启动，先从本地cache加载数据
-(void)readCacheHosts:(NSDictionary *)hosts;

-(void)arrivalTimeAndExecuteLookup;

// 添加预解析域名，并立即启动查询
-(void)addPreResolveHosts:(NSArray *)hosts;

// 添加单个域名，返回当前拥有的该域名的信息，然后决定是否要查询
-(HttpdnsHostObject *)addSingleHostAndLookup:(NSString *)host;

-(void)executeALookupActionWithHosts:(NSArray *)hosts retryCount:(int)count;

-(void)mergeLookupResultToManager:(NSArray *)result forHosts:(NSArray *)hosts;

-(HttpdnsHostObject *)addSingleHostAndLookupSync:(NSString *)host;

-(void)resetAfterNetworkChanged;
@end
