//
//  CCPRequestOperation.h
//  CloudPush
//
//  Created by wuxiang on 14-8-14.
//  Copyright (c) 2014年 ___alibaba___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCPURLRequest.h"
#import "CCPURLResponse.h"
 



typedef void (^successCallBack) (CCPURLRequest *ccpRequest,CCPURLResponse *ccpResponse);
typedef void (^failureCallBack) (CCPURLRequest *ccpRequest, CCPURLResponse *ccpResponse, NSError *error);

@interface CCPRequestOperation : NSObject 

-(void) doRequest:(CCPURLRequest *) ccpRequest success :(successCallBack) successCallBack failure: (failureCallBack)failureCallBack timeout:(NSTimeInterval) timeout;

/**
 *   http
 *
 *  @param ccpRequest      request 请求
 *  @param successCallBack 成功回调
 *  @param failureCallBack 失败回调
 */
-(void) doHttpRequest:(CCPURLRequest *) ccpRequest success :(successCallBack) successCallBack failure: (failureCallBack)failureCallBack ;

-(void) doHttpRequest:(CCPURLRequest *) ccpRequest success :(successCallBack) successCallBack failure: (failureCallBack)failureCallBack timeout:(NSTimeInterval) timeout;


/**
 *  tcp
 *
 *  @param ccpRequest request 请求
 *  @param successCallBack 成功回调
 *  @param failureCallBack 失败回调
 */
-(void) doRpcRequest:(CCPURLRequest *) ccpRequest success :(successCallBack) successCallBack failure: (failureCallBack)failureCallBack;

-(void) doRpcRequest:(CCPURLRequest *) ccpRequest success :(successCallBack) successCallBack failure: (failureCallBack)failureCallBack timeout:(NSTimeInterval) timeout;


@end
