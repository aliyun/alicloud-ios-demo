//
//  ALBBRpcProtocol.h
//  ALBBRpcSDK
//
//  Created by wuxiang on 15/4/22.
//  Copyright (c) 2015年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCPURLRequest.h"
#import "CCPRequestOperation.h"


/**
 * 说明：默认走http, 如果存在tcp的实现，则直接走tcp,如果没有，则直接http
 */
@protocol ALBBRpcProtocol<NSObject>


+(id<ALBBRpcProtocol>) getInstance;

@required
-(void) executeRequest:(CCPURLRequest *) ccpRequest
              success :(successCallBack) successCallBack
               failure:(failureCallBack)failureCallBack
               timeout:(NSTimeInterval) timeout;

@end
