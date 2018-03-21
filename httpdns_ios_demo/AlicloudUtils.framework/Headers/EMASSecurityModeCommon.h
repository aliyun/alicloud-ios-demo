//
//  EMASSecurityModeCommon.h
//  AlicloudUtils
//
//  Created by junmo on 2018/3/11.
//  Copyright © 2018年 Ali. All rights reserved.
//

#ifndef EMASSecurityModeCommon_h
#define EMASSecurityModeCommon_h

#define NotNilCallback(callback)\
if (callback) {\
    callback();\
}

#define NotNilCallback1(callback, param)\
if (callback) {\
    callback(param);\
}

#define NotNilCallback2(callback, param1, param2)\
if (callback) {\
    callback(param1, param2);\
}

typedef void (^SDKCheckSuccessHandler)(void);
typedef void (^SDKCheckCrashHandler)(NSUInteger crashCount);

#endif /* EMASSecurityModeCommon_h */
