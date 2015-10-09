//
//  ALBBMACProxy.h
//  ALINetworkSDK
//
//  Created by nanpo.yhl on 15-3-9.
//  Copyright (c) 2015年 nanpo.yhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBBMACProxy : NSObject

@property(nonatomic, copy)NSString* proxyHost;
@property(nonatomic, assign)uint32_t proxyIp;
@property(nonatomic, assign)uint16_t proxyPort;
@property(nonatomic, copy)NSString* proxyUserName;
@property(nonatomic, copy)NSString* proxyUserPasswd;


-(id)initWithHost:(NSString*)host ip:(uint32_t)ip port:(uint16_t)port userName:(NSString*)userName
       userPasswd:(NSString*)userPasswd;

@end
