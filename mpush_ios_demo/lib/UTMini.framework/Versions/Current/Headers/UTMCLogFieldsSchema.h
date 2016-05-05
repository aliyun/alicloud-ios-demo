//
//  UTMCLogFieldsSchema.h
//  minimalUT4ios
//  UT日志中各个字段对应的名称
//  Created by 宋军 on 14-8-6.
//  Copyright (c) 2014年 ___SONGJUN___. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _UTMC_PRIORITY_KEY_                          @"_log_priority_key_"

#define _UTMC_LOG_LEVEL_URGENT_                      @"9"
#define _UTMC_LOG_LEVEL_HIGH_                        @"8"
#define _UTMC_LOG_LEVEL_L7_                          @"7"
#define _UTMC_LOG_LEVEL_L6_                          @"6"
#define _UTMC_LOG_LEVEL_L5_                          @"5"
#define _UTMC_LOG_LEVEL_L4_                          @"4"
#define _UTMC_LOG_LEVEL_NROMAL_                      @"3"
#define _UTMC_LOG_LEVEL_L2_                          @"2"
#define _UTMC_LOG_LEVEL_L1_                          @"1"
#define _UTMC_LOG_LEVEL_LOW_                         @"0"

@class UTMCLogFieldsSchema;
/*****获取log日志每个字段对应的key string****************/
#define __UTMCLogFieldsSchema(x) [[UTMCLogFieldsSchema getInstance] getLogFiledKeyStr:x]
typedef enum _UTMCLogFieldSchema{
    IMEI
    ,IMSI
    ,BRAND
    ,DEVICE_MODEL
    ,RESOLUTION
    ,CARRIER
    ,ACCESS
    ,ACCESS_SUBTYPE
    ,CHANNEL
    ,APPKEY
    ,APPVERSION
    ,LL_USERNICK
    ,USERNICK
    ,LL_USERID
    ,USERID
    ,LANGUAGE
    ,OS
    ,OSVERSION
    ,SDKVERSION
    ,START_SESSION_TIMESTAMP
    ,UTDID
    ,RESERVE1
    ,RESERVE2
    ,RESERVE3
    ,RESERVE4
    ,RESERVE5
    ,RESERVES
    ,RECORD_TIMESTAMP
    ,PAGE
    ,EVENTID
    ,ARG1
    ,ARG2
    ,ARG3
    ,ARGS// args字段，用来和老的SDK 兼容，外部如果需要把参数加到args中，那么必须使用其他任意不包含在本列表的字段
} UTMCLogFieldSchema ;

@interface UTMCLogFieldsSchema : NSObject{
@private
    NSArray * mUTMCLogFieldsArr;
}
+(UTMCLogFieldsSchema *) getInstance;

-(NSString *) getLogFiledKeyStr:(UTMCLogFieldSchema) logFiledSchema;

-(NSArray *) getLogFiledKeyArr;
@end
