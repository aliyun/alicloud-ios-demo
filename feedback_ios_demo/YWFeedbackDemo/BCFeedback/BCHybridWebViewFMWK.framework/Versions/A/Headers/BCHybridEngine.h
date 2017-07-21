//
//  XBHybridEngine.h
//  xBlink
//
//  Created by admin on 14-11-11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BCHybridConnector.h"

#define YWHybridEngine BCHybridEngine

typedef void(^YWHybridEngineBlock)(NSString *event, NSDictionary *params, WQHandlerReturnBlock retBlock, UIWebView *webView, UIViewController * viewController);


@interface YWHybridEngine : NSObject
@property (nonatomic, weak) UIWebView *webView;
@property (strong, nonatomic, readonly) YWHybridConnector *bridgeConnector;
@property (strong, nonatomic) NSString *appKey;

- (instancetype)initWithAppKey:(NSString *)appKey
                   withWebView:(UIWebView *)webView;

//处理Request
- (BOOL)handleRequest:(NSURLRequest *)request;
- (void)registerBridgeEvent:(NSString *)event handler:(YWHybridEngineBlock)engineBlock;
- (void)registerBridgeModule:(NSString *)module andMethod:(NSString *)method handler:(YWHybridEngineBlock)engineBlock;
- (void)clearBridgeEvent;

//兼容千牛接口
- (void)addInstanceObserver:(id)observer selector:(SEL)aSelector oncall:(NSString*) methodName;
- (void)removeInstanceObserver:(NSString*) methodName;
@end
