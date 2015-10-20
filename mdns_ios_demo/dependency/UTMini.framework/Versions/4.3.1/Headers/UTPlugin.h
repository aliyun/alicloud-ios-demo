//
//  UTPlugin.h
//  minimalUT4ios
//
//  Created by 宋军 on 15/2/27.
//  Copyright (c) 2015年 ___ALIBABA___. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *UT约定的插件方传递插件类型的key
 *UT通过该key对应的value值，将日志分发到对应插件进行处理
 */
#define UT_PLUGIN_TYPE_KEY @"_ut_plugin_type_key_dfc0aa8"

//插件必须遵循的protocol
@protocol UTPlugin <NSObject>

/*
 *获取当前插件订阅的消息类型
 *一般为UT_PLUGIN_TYPE_KEY对应的value值，也可以订阅其它插件的日志
 *return:消息类型的数组，即有可能订阅多个消息
 */
-(NSArray *) returnRequiredMsgIds;

/*
 *UT将日志通过msgId分发给响应的插件，插件对日志进行处理
 *msgId:消息类型
 *pLogMap:UT生成的一条完整日志，插件可以对日志进行处理
 */
-(void) onPluginMsgArrivedFromSDK:(NSString *) msgId withLogMap:(NSDictionary *) pLogMap;

/*
 *当UT检测到crash时，通知插件方，插件方在该函数中进行相关crash善后处理
 *如将插件缓存的已经处理的日志发送给UT等。
 *例如:聚合插件(将多条日志合并成1条)即使没有达到deliverMsgToSDK的条件，当crash发生时也需要调用该函数。
 */
-(void) onCrashOccur;

@end

//插件的基类,必须继承
@interface UTPlugin : NSObject

/*
 *插件方将日志处理(可以是一条日志也可以是多条日志)的结果传给UT
 *pFullLogMap:插件方处理的结果日志，在onPluginMsgArrivedFromSDK塞入的日志map
 *上做的处理
 */
-(void) deliverMsgToSDK:(NSDictionary *) pFullLogMap;

@end