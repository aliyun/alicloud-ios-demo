//
//  BCConstants.h
//  WQConnector
//
//  Created by qinghua.liqh on 14-2-22.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

//Session
#define PARAMETER_IS_RESPONSE   @"session_is_response"
#define PARAMETER_SEQUENCE      @"session_sequence"
#define PARAMETER_EVENT         @"session_event"
#define PARAMETER_CALLBACKURL   @"session_callbackurl"
#define PARAMETER_CALLAPPKEY    @"session_appkey"
#define PARAMETER_PARAMS        @"session_params"
#define PARAMETER_RETCODE       @"session_retcode"  //同RETURN_HANDLER_CODE.

#define PARAMETER_APPKEY        @"appkey"
#define PARAMETER_DESTAPPKEY    @"destAppkey"
#define PARAMETER_AUTHSTRING    @"authString"

/*
//WQHandler特有参数(保留使用).
#define PARAMETER_ACTION_HOST      @"wq_action_host"
#define PARAMETER_ACTION_PATH      @"wq_action_path"
#define PARAMETER_ACTION_SCHEME    @"wq_action_scheme"
#define PARAMETER_ACTION_URI       @"wq_action_uri"
*/

//WQHandler返回值 key定义
#define RETURN_HANDLER_CODE         @"handler_code"   //返回码, 成功是可忽略.
#define RETURN_HANDLER_CODE_OK      @"0"              //成功
#define RETURN_HANDLER_CODE_ERR     @"1"              //失败
#define RETURN_HANDLER_CONTENT      @"handler_result" //执行结果.


//通用参数
#define PARAMETER_EXTRA_HEADER      @"__wq_extra_"
#define PARAMETER_FORM              @"__wq_extra_from" //调用来源
