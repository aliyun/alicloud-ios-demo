//
//  UT.h
//  miniUTSDK
//
//  Created by 宋军 on 15/5/19.
//  Copyright (c) 2015年 ___SONGJUN___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIWebView.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIView.h>
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
+(void) h5UT:(NSDictionary *) dataDict view:(UIWebView *) pView viewController:(UIViewController *) pViewController;


+(void) setH5Url:(NSString *) url ;


/**
 * @brief                           更新ViewController对应的页面名称
 *
 * @param          pViewController  UIViewController
 *
 * @param          pPageName        UIViewController 对应的新页面名称
 *
 */
+(void) et_updateViewControllerPageName:(UIViewController *) viewController pageName:(NSString *) pPageName ;


/**
 * @brief                           更新view对应的页面名称
 *
 * @param          pView            UIViewController
 *
 * @param          pPageName        UIViewController 对应的新页面名称
 *
 */
+(void) et_updateViewPageName:(UIView *) aView pageName:(NSString *) pPageName ;

/**
 * @brief                       无痕UIView页面进入.
 *                              调用顺序:SDK 异步init完成之后.
 *                              必须配合 easyTraceUIViewPageLeave 一起使用
 *
 * @param          pView        UIView形态的页面
 *
 * @param          properties   UIView的埋点属性
 *
 */
+(void) et_viewEnter:(UIView *) view properties:(NSDictionary *) pProperties ;


/**
 * @brief                       无痕UIView页面离开.
 *                              调用顺序:SDK 异步init完成之后.
 *                              必须配合 easyTraceUIViewPageEnter 一起使用
 *
 * @param          pView        UIView形态的页面
 *
 * @param          properties   UIView的埋点属性
 *
 */
+(void) et_viewLeave:(UIView *) view properties:(NSDictionary *) pProperties ;



/**
 * @brief                               更新ViewController页面携带的属性.
 *                                      调用顺序:SDK 异步init完成之后.
 *
 * @param          viewControllerName   UIViewController对象
 *
 * @param          properties           页面的埋点属性
 *
 */
+(void) et_updateViewControllerProperties:(UIViewController *) viewController properties:(NSDictionary *) pProperties ;



/**
 * @brief                               更新UIView页面携带的属性.
 *                                      调用顺序:SDK 异步init完成之后.
 *
 * @param          viewName             UIView对象
 *
 * @param          properties           页面的埋点属性
 *
 */
+(void) et_updateViewProperties:(UIView *) view properties:(NSDictionary *) pProperties ;

+(void) urlNavigation:(UIViewController *) viewController url:(NSURL *)pUrl ;

+(void) ctrlClickedWithNoPagePrefix:(NSString *)controlName onPage:(NSObject *)pageName args:(NSDictionary *)dict;

+(void) ctrlClicked:(NSString *)controlName onPage:(NSObject *) pageName args:(NSDictionary *) dict;

+(void) ctrlClicked:(NSString *)controlName args:(NSDictionary *) dict;

/**
 * @brief                       统计控件点击.
 *
 * @param          controlName  控件名称
 *
 * @warning                     *Important:* 埋点所在的页面必须埋点pageEnter,自动页面埋点除外
 *
 *                              最佳建议:页面中的元素尽量全部打点,提高统计精度
 *
 *                              调用顺序:preInit->init->ctrlClicked.
 *
 *                              最佳实践:[UT ctrlClicked:@"Buy"];控件名称必须是全英文,每个单词的首字母大写,建议不包含button,list,listitem等控件相关的名称
 *
 *                              最佳位置:页面中
 *
 *
 */
+(void) ctrlClicked:(NSString *)controlName __deprecated;

+(void) ctrlClicked:(NSString *)controlName onPage:(NSObject *) pageName ;

/**
 * @brief                       统计用户登录/登出.
 *
 * @param          usernick     用户昵称,如 AAAAAA
 *
 * @warning                     必需:希望埋上
 *
 *                              调用顺序:初始化代码后->updateUserAccount.
 *
 *                              最佳实践:用户登录:[UT updateUserAccount:@"*******A"].
 *                              用户切换:[UT updateUserAccount:@"*******B"].
 *                              用户注销:[UT updateUserAccount:@""].
 *
 *                              最佳位置:成功或失败的登录API返回之后
 *
 *                              *Important:* 登录/切换/登出埋点必须是登录Api调用成功之后调用,反之会统计虚高
 *
 *
 */
+(void) updateUserAccount:(NSString *)usernick userid:(NSString *) userid ;

+(void) updateUserAccount:(NSString *) usernick ;

+(void) updateUserAccount:(NSString *) usernick
                   userid:(NSString *) userid
                     args:(NSDictionary *) dict __deprecated;

/**
 * @brief                       统计用户注册.
 *
 * @param          usernick     用户昵称,如 "AAAAAA"
 *
 * @warning                     最佳建议:有的话,希望埋上
 *
 *                              调用顺序:初始化代码后->userRegister.
 *
 *                              *Important:* 必须是注册Api调用成功之后调用,反之会统计虚高
 *
 *
 */
+(void) userRegister:(NSString *) usernick     ;

/**
 * @brief                       普通自定义埋点.
 *
 * @param          eventId      事件ID，使用前，需要在我们的网站去登记
 *
 * @param          dict         事件携带的属性
 *
 * @warning                     调用顺序:初始化代码后->commitEvent.
 *
 *
 */
+ (void)commitEvent:(NSString *) eventId dict:(NSDictionary *) pDict;

/**
 * @brief                       自定义埋点(DEPRECATED).
 *
 * @param          eventId      行为ID,若需要使用,需要和我们沟通
 *
 * @param          arg1         参数1
 *
 * @param          arg2         参数2
 *
 * @param          arg3         参数3
 *
 * @param          args         参数s
 *
 * @param          dict         需要传递到args中去的kv参数对
 *
 * @warning                     调用说明:我们可以自主的控制埋点的格式以及内容,eventId这个参数对应行为记录的eventid,arg1对应行为记录的arg1,依次类推.
 *
 *                              调用顺序:preInit->init->commitEvent.
 *
 *
 */
+ (void)commitEvent:(int)eventId
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3 args:(NSDictionary *) dict;


+ (void)commitEvent:(NSObject *)page
            eventID:(int)eventID
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *) dict;

+ (void)commitEvent:(int)eventId ;

+ (void)commitEvent:(int)eventId
               arg1:(NSString *)arg1 ;
+ (void)commitEvent:(int)eventId
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2 ;

+ (void)commitEvent:(int)eventId
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3 ;

/**
 * @brief                       时长自定义埋点[开始].
 *
 * @param          eventId      事件ID，使用前，需要在我们的网站去登记，开始和结束必须使用相同的EventID
 *
 * @param          dict         事件携带的属性
 *
 * @warning                     时长统计的EventID必须有且仅有一个路径，也就是全局只能用一次，并且不能把时长和普通的混用
 *
 *                              调用顺序:初始化代码后->commitEvent.
 *
 *
 */
+ (void)commitEventBegin:(NSString *) eventId dict:(NSDictionary *) pDict;

/**
 * @brief                       时长自定义埋点[结束].
 *
 * @param          eventId      事件ID，使用前，需要在我们的网站去登记，开始和结束必须使用相同的EventID。
 *
 * @param          dict         事件携带的属性
 *
 * @warning                     时长统计的Event必须有且仅有一个路径，也就是全局只能用一次，并且不能把时长和普通的混用
 *
 *                              调用顺序:preInit->init->commitEvent.
 *
 *
 */
+ (void)commitEventEnd:(NSString *) eventId dict:(NSDictionary *) pDict;

/**
 * @brief                       获取SDK生成的设备唯一标识.
 *
 * @warning                     调用说明:这个设备唯一标识是持久的,并且格式安全,iOS6以及以下,多应用互通.
 *
 *                              调用顺序:utdid任意时刻都可以调用.
 *
 * @return                      24字节的设备唯一标识.
 */
+(NSString *) utdid;

/**
 * @brief                       获取SDK生成的会话ID.
 *
 * @warning                     调用说明:SDK初始化完成之后,会分配一个唯一的会话ID.
 *
 *                              调用顺序:SDK 异步init完成之后.
 *
 *
 * @return                      格式:"utdid_appkey_timestamp".
 */
+(NSString *) utsid;

/**
 * @brief                       用户塞入参数到reverses字段.
 *
 *
 * @param    properties         需要传递到reverse中去的kv参数对
 *
 *
 * @warning                     调用顺序:初始化代码后->updateSessionProperties.
 *
 *                              最佳实践:[UT updateSessionProperties:@"******"]
 *
 *
 *
 */
+(void) updateSessionProperties:(NSDictionary *) properties  ;

+(NSString *) currentPageName;

#pragma mark 以下接口均为空实现,仅为了编译能通过,千万不要调用该接口
+(void) turnOffCrashHandler     __deprecated;
+(void) pageEnter:(NSObject *) pageName __deprecated;
+(void) pageEnter:(NSObject *) pageName args:(NSDictionary *) dict __deprecated;
+(void) pageLeave:(NSObject *) pageName __deprecated;
+(void) pageLeave:(NSObject *) pageName args:(NSDictionary *) dict __deprecated;
+(void) et_viewControllerCtrlClicked:(UIViewController *) viewController actionName:(NSString *) actionName properties:(NSDictionary *) pProperties __deprecated;
+(void) et_viewCtrlClicked:(UIView *) viewName actionName:(NSString *) actionName properties:(NSDictionary *) pProperties __deprecated;
+(void) et_ctrlClickedWithQueryParentViewController:(UIView *) viewName actionName:(NSString *) actionName properties:(NSDictionary *) pProperties __deprecated;

+(void) preInit __deprecated;
+(void) setAppVersion : (NSString *) appVersion __deprecated;
+(void) turnOnSecuritySDKSupport __deprecated;
+(void) setChannel : (NSString *) channel __deprecated;
+(void) turnOffLogFriendly __deprecated;
+(void) turnOnDebug __deprecated;
+(void) turnOnGlobalNavigationTrack:(NSArray *) excludePages __deprecated;
+(void) bindPageName:(NSDictionary *) dict __deprecated;
+(void) init __deprecated;
+(void) updatePageProperties:(NSObject *) pPageName properties:(NSDictionary *) pProperties __deprecated;
+(void) userRegister:(NSString *) usernick args:(NSDictionary *) dict      __deprecated;

+(void) turnOffEasyTrace    __deprecated;
+(void) uninit              __deprecated;
+(void) useSimplePageName   __deprecated;

+(void) itemSelected:(NSString *)controlName
            andIndex:(int) index        __deprecated;

+(void) itemSelected:(NSString *)controlName
              onPage:(NSObject *) pageName
            andIndex:(int) index           __deprecated;


+(void) itemSelected:(NSString *)controlName
            andIndex:(int) index
                args:(NSDictionary *) dict    __deprecated;

+(void) itemSelected:(NSString *)controlName
              onPage:(NSObject *) pageName
            andIndex:(int) index
                args:(NSDictionary *) dict     __deprecated;

+(void) updatePageName:(NSObject *) pOPageName newPageName:(NSString *) pageName    __deprecated;

+(void) forceUpload     __deprecated;

+(void) updateGPSInfo:(NSString *) pageName
            longitude:(double) longitude
             latitude:(double) latitude     __deprecated;

+(void) updateGPSInfo:(NSString *) pageName
            longitude:(double)longitude
             latitude:(double) latitude
                 args:(NSDictionary *) dict     __deprecated;

+(void) pushArrive:(NSString *) pushName        __deprecated;
+(void) pushArrive:(NSString *) pushName args:(NSDictionary *) dict     __deprecated;
+(void) pushDisplay:(NSString *) pushName               __deprecated;
+(void) pushDisplay:(NSString *) pushName args:(NSDictionary *) dict        __deprecated;
+(void) pushView:(NSString *) pushName          __deprecated;
+(void) pushView:(NSString *) pushName args:(NSDictionary *) dict           __deprecated;
+(void) searchKeyword:(NSString *) keyword underCategory:(NSString *) category      __deprecated;
+(void) searchKeyword:(NSString *) keyword underCategory:(NSString *) category args:(NSDictionary *) dict __deprecated;
+(void) share:(NSString *) content underCategory:(NSString *) category      __deprecated;

+(void) share:(NSString *) content underCategory:(NSString *) category args:(NSDictionary *) dict       __deprecated;
+(void) updateUTSIDToCookie:(NSString *) url                __deprecated;
+(void) updateUTCookie:(NSString *) url dict:(NSDictionary *) dict          __deprecated;
+(void) trade:(NSString *) orderID              __deprecated;
+(void) trade:(NSString *) orderID args:(NSDictionary *) dict               __deprecated;
+(void) h5UT:(NSDictionary *) dataDict vc:(UIWebView *) view                __deprecated;
+(void) updateViewControllerPageProperties:(UIViewController *) viewController properties:(NSDictionary *) pProperties  __deprecated;
//for react native  to use,temporary
+(void) rn_pageEnter:(NSObject *) pageName args:(NSDictionary *) dict           __deprecated;
+(void) rn_pageLeave:(NSObject *) pageName args:(NSDictionary *) dict           __deprecated;
+(void) rn_updatePageProperties:(NSObject *) pPageName properties:(NSDictionary *) pProperties      __deprecated;

@end
