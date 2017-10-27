//
//  AlicloudBeaconService.h
//  AlicloudBeacon
//
//  Created by junmo on 2017/7/6.
//  Copyright © 2017年 junmo. All rights reserved.
//

#ifndef AlicloudBeaconService_h
#define AlicloudBeaconService_h

@interface AlicloudBeaconConfiguration : NSObject

- (instancetype)initWithData:(NSData *)data;
- (id)getConfigureItemByKey:(NSString *)key;

@end

typedef void (^AlicloudBeaconCallbackHandler)(BOOL res, NSError *error);

@interface AlicloudBeaconService : NSObject

- (instancetype)initWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
                    SDKVersion:(NSString *)SDKVersion
                         SDKID:(NSString *)SDKID;

- (void)enableLog:(BOOL)enabled;
- (BOOL)isLogEnabled;

//- (void)getBeaconConfigByKey:(NSString *)key
//           completionHandler:(void(^)(AlicloudBeaconConfiguration *configuration, NSError *error))completionHandler;

- (void)getBeaconConfigStringByKey:(NSString *)key
           completionHandler:(void(^)(NSString *result, NSError *error))completionHandler;

@end

#endif /* AlicloudBeaconService_h */
