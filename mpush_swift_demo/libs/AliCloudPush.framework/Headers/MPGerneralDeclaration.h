//
//  MPGerneralDeclaration.h
//  CloudPushSDK
//
//  Created by junmo on 16/7/26.
//  Copyright © 2016年 aliyun.mobileService. All rights reserved.
//

#ifndef MPGerneralDeclaration_h
#define MPGerneralDeclaration_h

#import "CloudPushCallbackResult.h"

typedef void (^CallbackHandler)(CloudPushCallbackResult *res);

// 保证callback不为空
#define NotNilCallback(funcName, paras)\
if (funcName) {\
funcName(paras);\
}

#endif /* MPGerneralDeclaration_h */
