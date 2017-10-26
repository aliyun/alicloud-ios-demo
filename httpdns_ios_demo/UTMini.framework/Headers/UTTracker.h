//
//  UTTracker.h
//  miniUTInterface
//
//  Created by 宋军 on 14-10-14.
//  Copyright (c) 2014年 ___SONGJUN___. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIViewController.h>
//#import <UIKit/UIWebView.h>
@class UTDSDKInfo;

typedef enum _UTPageStatus{
    UT_H5_IN_WebView//设置容器中的H5页面事件的eventid为2001,不设置默认为2006
} UTPageStatus;

@interface UTTracker : NSObject

@property (readonly,copy) UTDSDKInfo * mSdkinfo;

-(id) initWithTrackId:(NSString *) pTrackId __deprecated;

-(id) initWithAppKey:(NSString *) pAppkey
           appsecret:(NSString *) pAppSecret
            authcode:(NSString *) pAuthCode
        securitySign:(BOOL) securitySign;

-(id) initWithTracker:(UTTracker *) pTracker trackid:(NSString *) pTrackId;

-(NSString *) getAppKey;

-(void) setGlobalProperty:(NSString *) pKey value:(NSString *) pValue;

-(void) removeGlobalProperty:(NSString *) pKey;

-(NSString *) getGlobalProperty:(NSString *) pKey;

-(void) send:(NSDictionary *) pLogDict;

#pragma mark 页面埋点
/**
 * @brief                   页面进入.
 *
 * @param     pPageObject   页面对象,如viewcontroller指针
 *
 * @warning                 调用说明:1.必须和pageDisAppear配对使用,否则不会成功埋点
 *                                  2.确定页面名称优先级:updatePageName > NSStringFromClass(pObject.class)
 *
 *                          最佳位置:若是viewcontroller页面,则需在viewDidAppear函数内调用
 */
-(void) pageAppear:(id) pPageObject;

/**
 * @brief                   页面进入.
 *
 * @param     pPageObject   页面对象,如viewcontroller指针
 * @param     pPageName     页面名称,如Page_Detail
 *
 * @warning                 调用说明:1.必须和pageDisAppear配对使用,否则不会成功埋点
 *                                  2.确定页面名称优先级:updatePageName > pPageName > NSStringFromClass(pObject.class)
 *                                    若当调用pageAppear时已知页面名称,强烈建议使用该接口
 *                          最佳位置:若是viewcontroller页面,则需在viewDidAppear函数内调用
 */
-(void) pageAppear:(id) pPageObject withPageName:(NSString *) pPageName;

/**
 * @brief                   页面离开.
 *
 * @param     pPageObject   页面对象,如viewcontroller指针
 *
 * @warning                 调用说明:必须和pageAppear配对使用,否则不会成功埋点
 *
 *                          最佳位置:若是viewcontroller页面,则需在viewDidDisAppear函数内调用
 */
-(void) pageDisAppear:(id) pPageObject;

/**
 * @brief                   更新页面业务参数.
 *
 * @param     pPageObject   页面对象,如viewcontroller指针
 * @param     pProperties   业务参数,kv对
 *
 * @warning                 调用说明:必须在pageDisAppear之前调用
 *
 *                          最佳位置:在pageDisAppear之前调用即可
 */
-(void) updatePageProperties:(id) pPageObject properties:(NSDictionary *) pProperties;

/**
 * @brief                   更新页面业务参数.
 *
 * @param     pProperties   传给下一个页面业务参数,kv对
 *
 * @warning                 调用说明:必须在下一个页面pageAppear之前调用,否则会携带错误
 *
 *                          最佳位置:必须在下一个页面pageAppear之前调用
 */
-(void) updateNextPageProperties:(NSDictionary *) pProperties;

#pragma  mark 页面埋点的辅助函数
/**
 * @brief                   更新页面名称.
 *
 * @param     pPageObject   页面对象,如viewcontroller指针
 * @param     pPageName     更新后的页面名称
 *
 * @warning                 调用说明:只有当调用pageAppear时还未知页面名称,后续可使用该接口更新
 *
 *                          最佳位置:在pageDisAppear之前调用
 */
-(void) updatePageName:(id) pPageObject pageName:(NSString *) pPageName;

/**
 * @brief                   更新页面url.
 *
 * @param     pPageObject   页面对象,如viewcontroller指针
 * @param     pUrl          页面对应的url
 *
 * @warning                 调用说明:如手淘统一导航将每次页面跳转的url塞给对应的viewcontroller
 *
 *                          最佳位置:在pageDisAppear之前调用
 */
-(void) updatePageUrl:(id) pPageObject url:(NSURL *) pUrl;

/**
 * @brief                   更新页面状态.
 *
 * @param     pPageObject   页面对象,如viewcontroller指针
 * @param     aStatus       页面状态 enum类型
 *
 * @warning                 调用说明:告知页面处于某些特殊的业务场景,如回退等
 *
 *                          最佳位置:必须在pageAppear之前调用
 */
-(void) updatePageStatus:(id) pPageObject status:(UTPageStatus) aStatus;


-(void) skipPage:(id) pPageObject;

- (void) ctrlClicked:(NSString *)controlName onPage:(NSObject *) pageName args:(NSDictionary *) dict;

@end
