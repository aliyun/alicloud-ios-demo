//
//  TDSServiceProvider.h
//  TestTDS
//
//  Created by 郭天 on 15/5/12.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDSService.h"

@interface TDSServiceProvider : NSObject<TDSService>

+ (TDSServiceProvider *)getService;

@end
