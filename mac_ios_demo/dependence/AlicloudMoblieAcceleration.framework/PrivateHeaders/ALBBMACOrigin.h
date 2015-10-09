//
//  ALBBMACOrigin.h
//  ALINetworkSDK
//
//  Created by nanpo.yhl on 15-3-7.
//  Copyright (c) 2015年 nanpo.yhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBBMACOrigin : NSObject <NSCopying>

@property (nonatomic, readonly) NSString *schema;
@property (nonatomic, readonly) NSString *host;
@property (nonatomic, readonly) in_port_t port;
@property (nonatomic, readonly) uint32_t cindex;
@property (nonatomic, strong)NSString* urlHashCode;

- (id)initWithString:(NSString*)urlString;
- (id)initWithURL:(NSURL *)url;
- (id)initWithSchema:(NSString*)schema
                Host:(NSString *)host
                port:(in_port_t)port;

- (id)copyWithZone:(NSZone *)zone;

@end
