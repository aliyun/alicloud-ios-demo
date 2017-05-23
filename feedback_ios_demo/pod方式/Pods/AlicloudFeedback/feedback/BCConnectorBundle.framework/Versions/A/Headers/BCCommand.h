//
//  WQCommand.h
//  WQOpenSDK
//
//  Created by qinghua.liqh on 14-6-9.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCEventCallback.h"

#define WQCommand BCCommand

@interface WQCommand : NSObject
@property (assign, nonatomic) BOOL canOpenUI;
@property (assign, nonatomic) long timeoutInMS;
@property (strong, nonatomic) NSString *event;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSDictionary *params;
@property (strong, nonatomic) WQEventCallback *callback;
@property (strong, nonatomic) NSDictionary *extraParams;
@end
