//
//  AppMonitorAlarm.h
//  AppMonitor
//
//  Created by junzhan on 14-9-15.
//  Copyright (c) 2014年 君展. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppMonitorBase.h"

@interface AppMonitorAlarm : AppMonitorBase
/**
 *  记录业务操作成功接口
 *
 *  @param page   页面名称,安卓iOS要相同. 命名规范:若之前埋点有页面名,则用原来的; 否则用"业务名_页面名"(无页面则"业务名"); 采用首字母大写驼峰方式. 如Shop_Detail, Shop_List
 *  @param monitorPoint 监控点名称,安卓iOS要相同,从@雷曼 获取
 *
 */
+ (void)commitSuccessWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint;

/**
 *  记录业务操作失败接口
 *
 *  @param page   页面名称,安卓iOS要相同. 命名规范:若之前埋点有页面名,则用原来的; 否则用"业务名_页面名"(无页面则"业务名"); 采用首字母大写驼峰方式. 如Shop_Detail, Shop_List
 *  @param monitorPoint 监控点名称,安卓iOS要相同,从@雷曼 获取
 *  @param errorCode 错误码，若为MTOP请求则传MTOP的错误码,否则请业务方对错误进行分类编码,方便统计错误类型占比
 *  @param errorMsg  错误信息，若位MTOP请求则传MTOP的错误信息, 否则请业务方自己描述错误, 方便自己查找原因
 */
+ (void)commitFailWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint errorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg;

/**
 *  记录业务操作成功接口
 *
 *  @param page   页面名称,安卓iOS要相同. 命名规范:若之前埋点有页面名,则用原来的; 否则用"业务名_页面名"(无页面则"业务名"); 采用首字母大写驼峰方式. 如Shop_Detail, Shop_List
 *  @param monitorPoint 监控点名称,安卓iOS要相同,从@雷曼 获取
 *  @arg 附加参数，用于做横向扩展
 */
+ (void)commitSuccessWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint arg:(NSString *)arg;

/**
 *  记录业务操作失败接口
 *
 *  @param page   页面名称,安卓iOS要相同. 命名规范:若之前埋点有页面名,则用原来的; 否则用"业务名_页面名"(无页面则"业务名"); 采用首字母大写驼峰方式. 如Shop_Detail, Shop_List
 *  @param monitorPoint 监控点名称,安卓iOS要相同,从@雷曼 获取
 *  @param errorCode 错误码，若为MTOP请求则传MTOP的错误码,否则请业务方对错误进行分类编码,方便统计错误类型占比
 *  @param errorMsg  错误信息，若位MTOP请求则传MTOP的错误信息, 否则请业务方自己描述错误, 方便自己查找原因
 *  @arg 附加参数，用于做横向扩展
 */
+ (void)commitFailWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint errorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg arg:(NSString *)arg;

@end
