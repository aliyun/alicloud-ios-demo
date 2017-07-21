//
//  ActionItem.h
//  WQConnector
//
//  Created by qinghua.liqh on 14-2-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WQActionItem BCActionItem

@interface WQActionItem : NSObject
@property (strong, nonatomic, readonly) NSString *scheme;
@property (strong, nonatomic, readonly) NSString *host;
@property (strong, nonatomic, readonly) NSString *path;
@property (strong, nonatomic, readonly) NSString *port;
@property (strong, nonatomic, readonly) NSDictionary *params;
@property (strong, nonatomic, readonly) NSString *urlString;


-(id)initWithString:(NSString *)uriString;
- (void)addParams:(NSDictionary *)params;
@end
