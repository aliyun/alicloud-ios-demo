//
//  UT.h
//  miniUTSDK
//
//  Created by 宋军 on 15/5/19.
//  Copyright (c) 2015年 ___SONGJUN___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UT : NSObject

////=====================================h5&Native接口=====================================
/**
 * @brief                       h5&Native打通
 *
 * @warning                     调用说明:由windwave封装，供aplus_wap.js调用
 *
 *
 *
 * @param       dataDict        aplus_wap.js采集的h5信息都通过该字典传进来,该字典中必须有key(funcType)
 *                              用来区分采集的是哪个事件信息，比如funcType=2001，则h5UT内部会调用
 *                              pageEnter来处理，funcType=2101，则调用ctrlClicked处理
 *
 */
+(void) h5UT:(NSDictionary *) dataDict view:(UIView *) pView viewController:(UIViewController *) pViewController;

@end
