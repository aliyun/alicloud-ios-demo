//
//  ALBBMACHostManager.h
//  ALBBMACSDK
//
//  Created by nanpo.yhl on 15/7/13.
//  Copyright (c) 2015年 com.taobao.com.cas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ALBBRpcSDK/ALBBRpcSDK.h>

#import <ALBBTDSSDK/TDSService.h>
#import <ALBBTDSSDK/TDSServiceProvider.h>

//#import "TDSService.h"
//#import "TDSServiceProvider.h"

@interface ALBBMACHostManager : NSObject

+(ALBBMACHostManager*)shareInstance;

-(void)allDomains;

-(NSString*)getCasDomain:(NSString*)host;

-(FederationToken*)getMACToken;

@end
