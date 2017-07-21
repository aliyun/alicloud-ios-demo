//
//  XBHybridWebView.h
//  WQOpenSDK
//
//  Created by qinghua.liqh on 14-2-25.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BCHybridEngine.h"

#define YWHybridWebView BCHybridWebView

@protocol YWBridgeCallDelegate <NSObject>
@optional
-(void) bridgeCall:(NSString*) event params:(NSDictionary*) params;
@end

typedef void ( ^YWHybridOpenUrlBlock ) (NSDictionary *urlInfo, BOOL *hasOpened) ;

@interface YWHybridWebView : UIWebView<UIWebViewDelegate>
@property (weak, nonatomic) id<YWBridgeCallDelegate>      bridgeCallDelegate;
@property (strong, nonatomic, readonly) YWHybridEngine  *bridgeEngine;
@property (nonatomic, weak, readonly)  UIViewController *viewController;
@property (strong, nonatomic)   NSString                *appKey;
@property (copy, nonatomic) YWHybridOpenUrlBlock        openUrlBlock;

- (instancetype)initWithFrame:(CGRect)frame onViewController:(UIViewController *)viewController;
- (instancetype)initWithFrame:(CGRect)frame onViewController:(UIViewController *)viewController enableBridge:(BOOL)enableBridge;

- (void)bridgeEnable:(bool) enable;

typedef BOOL (^InterceptUrlRegexMatched) (NSString *urlMatched);
- (void)registerInterceptUrlWithRegex:(NSString *)regex matchedBlock:(InterceptUrlRegexMatched)matchedBlock;
- (void)unRegisterInterceptUrlWithRegex:(NSString *)regex;
@end
