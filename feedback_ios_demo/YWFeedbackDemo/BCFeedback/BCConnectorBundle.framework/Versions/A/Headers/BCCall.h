//
//  WQCall.h
//  WQConnector
//
//  Created by qinghua.liqh on 14-2-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WQCall BCCall

@interface WQCall : NSObject
@property(strong, nonatomic) NSDictionary* context;
@property BOOL needMainThreadCallback;
@end
