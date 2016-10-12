//
//  MPGerneralDefinition.h
//  CloudPushSDK
//
//  Created by junmo on 16/10/11.
//  Copyright © 2016年 aliyun.mobileService. All rights reserved.
//

#ifndef MPGerneralDefinition_h
#define MPGerneralDefinition_h

#import "CloudPushCallbackResult.h"

typedef void (^CallbackHandler)(CloudPushCallbackResult *res);

// 保证callback不为空
#define NotNilCallback(funcName, paras)\
if (funcName) {\
funcName(paras);\
}

#endif /* MPGerneralDefinition_h */
