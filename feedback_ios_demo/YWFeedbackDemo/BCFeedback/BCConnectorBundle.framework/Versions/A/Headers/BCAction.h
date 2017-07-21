//
//  WQBaseAction.h
//  WQConnector
//
//  Created by qinghua.liqh on 14-2-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCHandlerResult.h"
#import "BCConnector.h"

#define WQAction BCAction

typedef void (^WQActionCallback)(WQHandlerResult *result);
@interface WQAction : NSObject
@property (nonatomic, strong) NSString *bindAppKey;
@property (nonatomic, strong, readonly) NSArray *actionItems;
@property (nonatomic, strong) NSDictionary *extraParams;


+ (BOOL)startAction:(NSString *)actionString manualStart:(BOOL)manualStart;
+ (BOOL)startAction:(NSString *)actionString withCallback:(WQActionCallback)callback  manualStart:(BOOL)manualStart;
+ (id)actionFromString:(NSString *)actionString;

- (id)initActionWithString:(NSString *)actionString;
- (BOOL)startWithCallback:(WQActionCallback)callback manualStart:(BOOL)manualStart;
- (BOOL)startWithCallback:(WQActionCallback)callback connector:(WQConnector *)connector manualStart:(BOOL)manualStart;
- (BOOL)startWithManualStart:(BOOL)manualStart;
- (void)addParams:(NSDictionary *)params;

@end
