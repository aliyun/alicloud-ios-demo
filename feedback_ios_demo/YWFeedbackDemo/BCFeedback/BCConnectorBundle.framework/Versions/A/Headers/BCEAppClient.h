//
//  WQEAppClient.h
//  WQConnector
//
//  Created by qinghua.liqh on 14-2-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCPluginConstants.h"
#import "BCPermission.h"
#import "BCEAppEntity.h"
#import "BCConnector.h"
#import "BCAuth.h"

#define WQEAppClient BCEAppClient

@interface WQEAppClient : NSObject
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *companyId;
@property (strong, nonatomic) WQEAppEntity *app;
@property (strong, nonatomic) WQAuth *appAuth;

#pragma mark - static
+ (void)registerClient:(NSString *)appKey client:(WQEAppClient *)client;
+ (void)unregisterClient:(NSString *)appKey;
+ (WQEAppClient *)getClient:(NSString *)appKey;
+ (void)clearAllClient;


#pragma mark - init
- (id)initWithApp:(WQEAppEntity *)app userId:(NSString *)userId companyId:(NSString *)companyId;

#pragma mark - 插件权限
- (BOOL)hasPermission:(WQPermission *)permission;
- (void)addPermission:(WQPermission *)permission;

#pragma mark - 授权相关
//得到Web调用callback地址.
- (NSString *)getCallbackForWeb;
- (NSString *)getHttpCallUrl:(NSString *)url withParams:(NSDictionary *)params;


/*
#pragma mark - top接口调用
-(WQConnectCode) asynCall:(NSString *)url                       //TOP网关地址
           requestMethod:(ITTRequestMethod)requestMethod       //method请求的方法(GET,POST)
                  params:(NSDictionary *)params                //请求参数
           callbackBlock:(ApiCallbackBlockType)callbackBlock   //请求回调
  needMainThreadCallBack:(Boolean)needMainThreadCallBack;      //是否需要在主线程返回
*/
@end
