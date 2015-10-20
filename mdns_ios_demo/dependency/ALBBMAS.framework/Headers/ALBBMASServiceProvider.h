//
//  ALBBMASServiceProtocolImpl.h
//  TestMAS
//
//  Created by 郭天 on 15/3/12.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBBMASServiceProtocol.h"

@interface ALBBMASServiceProvider : NSObject<ALBBMASServiceProtocol>

+ (ALBBMASServiceProvider *)getService;

@end
