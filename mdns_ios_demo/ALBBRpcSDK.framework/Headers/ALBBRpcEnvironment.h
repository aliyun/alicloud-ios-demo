//
//  ALBBRpcEnvironment.h
//  ALBBRpcSDK
//
//  Created by wuxiang on 15/4/21.
//  Copyright (c) 2015年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBBRpcSDK.h"
#import <DpaUtil/HTTPDNSMini.h>


@interface ALBBRpcEnvironment : NSObject  {
    
    
}

@property (nonatomic, readonly) ALBBRpcSDKEnvironmentEnum envEnum;



/**
 *  得到网关地址
 *
 *  @return
 */
-(NSString *) getGateWayUrl;

+(ALBBRpcEnvironment *) sharedInstance;


/**
 *  设置环境变量
 *
 *  @param env
 */
- (void) setEnvironment: (ALBBRpcSDKEnvironmentEnum) env;



#pragma mark 获取IP和新的url地址

- (NSString *) useHTTPDNSGetIP:(NSString *) confUrl;

@end
