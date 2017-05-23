//
//  WQPermission.h
//  WQConnector
//
//  Created by qinghua.liqh on 14-2-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WQPermission BCPermission

@interface WQPermission : NSObject
@property (strong, nonatomic) NSString* permissionName;
@end
