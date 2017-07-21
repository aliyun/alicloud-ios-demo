//
//  WQBridgeConfig.h
//  WQOpenSDK
//
//  Created by qinghua.liqh on 14-3-14.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#ifndef WQOpenSDK_WQBridgeConfig_h
#define WQOpenSDK_WQBridgeConfig_h

#define JS_HYBRID_SCHEME        @"hybrid"
/*
#define JS_SUCCESS_CALLBACK     @"window.WQ.onSuccess"
#define JS_FAILURE_CALLBACK     @"window.WQ.onFailure"
#define JS_FIREEVENT_CALLBACK   @"window.WQ.fireEvent"
*/

#define JS_FAILURE_CALLBACK        @"window.WindVane.onFailure"
#define JS_SUCCESS_CALLBACK        @"window.WindVane.onSuccess"
#define JS_FIREEVENT_CALLBACK      @"window.WindVane.fireEvent"

/** 返回JSON字段: 状态码 **/
#define MSG_RESULT_CODE_NAME        @"ret"
/** 返回JSON字段: 返回值 **/
#define MSG_RESULT_VALUE_NAME       @"value"

/** 成功返回 **/
#define MSG_RET_SUCCESS     @"HY_SUCCESS"
/** 失败返回 **/
#define MSG_RET_FAILED      @"HY_FAILED"
/** 取消 **/
#define MSG_RET_CANCEL      @"HY_CANCEL"
/** 关闭 **/
#define MSG_RET_CLOSE       @"HY_CLOSED"
/** 发生异常 **/
#define MSG_RET_EXP         @"HY_EXCEPTION"
/** 参数错误 **/
#define MSG_RET_PARAM_ERR   @"HY_PARAM_ERR"
/** 无此服务 **/
#define MSG_RET_NO_HANDLER  @"HY_NO_HANDLER"
/** 权限禁止 **/
#define MSG_RET_NO_PERMIT   @"HY_NO_PERMISSION"

#endif
