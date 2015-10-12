//
//  ALBBMANServiceProtocolImpl.h
//   
//
//  Created by 郭天 on 15/3/12.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBBMANServiceProtocol.h"

@interface ALBBMANServiceProvider : NSObject<ALBBMANServiceProtocol>

+ (ALBBMANServiceProvider *)getService;

@end
