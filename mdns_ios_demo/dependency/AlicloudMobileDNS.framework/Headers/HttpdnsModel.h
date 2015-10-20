//
//  HttpdnsModel.h
//  Dpa-Httpdns-iOS
//
//  Created by zhouzhuo on 5/1/15.
//  Copyright (c) 2015 zhouzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpdnsIpObject: NSObject<NSCoding> {
    NSString *ip;
}

@property (nonatomic, copy, getter=getIpString, setter=setIp:) NSString *ip;

@end


typedef NS_ENUM(NSInteger, HostState) {
    HttpdnsHostStateINITIALIZE,
    HttpdnsHostStateQUERYING,
    HttpdnsHostStateVALID
};



@interface HttpdnsHostObject : NSObject<NSCoding>

@property (nonatomic, strong, setter=setHostName:, getter=getHostName) NSString *hostName;
@property (nonatomic, strong, setter=setIps:, getter=getIps) NSArray *ips;
@property (nonatomic, setter=setTTL:, getter=getTTL) long long ttl;
@property (nonatomic, getter=getLastLookupTime, setter=setLastLookupTime:) long long lastLookupTime;
@property (atomic, setter=setState:, getter=getState) HostState currentState;

-(instancetype)init;

-(BOOL)isExpired;

-(BOOL)isAlreadyUnawailable;

-(NSString *)description;
@end



@interface HttpdnsToken : NSObject

@property (nonatomic, strong) NSString *accessKeyId;
@property (nonatomic, strong) NSString *accessKeySecret;
@property (nonatomic, strong) NSString *securityToken;
@property (nonatomic, strong) NSString *appId;

-(NSString *)description;
@end


@protocol HttpdnsCredentialProvider <NSObject>

-(NSString *)sign:(NSString *)stringToSign;

@end


@interface HttpdnsCustomSignerCredentialProvider : NSObject<HttpdnsCredentialProvider>

@property(nonatomic, copy) NSString *(^signerBlock)(NSString *);

-(instancetype)initWithSignerBlock:(NSString *(^)(NSString * stringToSign))signerBlock;

@end


#ifdef IS_DPA_RELEASE
@interface HttpdnsTokenGen : NSObject

@property(nonatomic, strong) NSString *appId;

+(instancetype)sharedInstance;

-(HttpdnsToken *)getToken;

@end
#endif



@interface HttpdnsLocalCache : NSObject

+(void)writeToLocalCache:(NSDictionary *)allHostObjectInManagerDict;

+(NSDictionary *)readFromLocalCache;

+(void)cleanLocalCache;
@end