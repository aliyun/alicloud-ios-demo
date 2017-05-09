//
//  WQPluginConstants.h
//  WQOpenSDK
//
//  Created by qinghua.liqh on 14-3-6.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#ifndef WQOpenSDK_WQPluginConstants_h
#define WQOpenSDK_WQPluginConstants_h

#pragma mark - Summary模板
typedef enum _WQSummaryTemplate {
    WQSummaryTemplateNormal = 0,
    WQSummaryTemplateSimple = 1,
    WQSummaryTemplateNumber = 2,
}WQSummaryTemplate;

#pragma mark - 数据更新模式
typedef enum _WQDataUpdateMode{
    WQDataUpdateModePull = 0,
    WQDataUpdateModePush = 1,
}WQDataUpdateMode;

#pragma mark - App类型
typedef enum _WQAppType {
    WQAppTypeNative = 0,
    WQAppTypeH5 = 1,
    WQAppType3rdApp = 2,
    WQAppTypePackaged = 3,
}WQAppType ;

#pragma mark - 类目类型
typedef enum _WQCategoryType {
    WQCategoryTypeSlot = 0,
    WQCategoryTypeGroup = 1
}WQCategoryType;

#pragma mark - 平台类型
#define WQPlatfromIOS       0x1
#define WQPlatfromAndroid   0x2
#define WQPlatfromPC        0x4
#define WQPlatfromWeb       0x8

#endif
