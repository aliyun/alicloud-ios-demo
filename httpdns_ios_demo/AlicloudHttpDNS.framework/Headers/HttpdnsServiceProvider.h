/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#import <Foundation/Foundation.h>
#import "HttpdnsDegradationDelegate.h"

#define ALICLOUD_HTTPDNS_DEPRECATED(explain) __attribute__((deprecated(explain)))

@interface HttpDnsService: NSObject

@property (nonatomic, assign, readonly) int accountID;
@property (nonatomic, copy, readonly) NSString *secretKey;
@property (nonatomic, weak, setter=setDelegateForDegradationFilter:) id<HttpDNSDegradationDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

- (instancetype)initWithAccountID:(int)accountID;

/*!
 * @brief 启用鉴权功能的初始化接口
 * @details 初始化、开启鉴权功能，并设置 HTTPDNS 服务 Account ID，鉴权功能对应的 secretKey。
 *          您可以从控制台获取您的 Account ID 、secretKey 信息。
 *          此方法会初始化为单例。
 * @param accountID 您的 HTTPDNS Account ID
 * @param secretKey 鉴权对应的 secretKey
 */
- (instancetype)initWithAccountID:(int)accountID secretKey:(NSString *)secretKey;

/*!
 * @brief 校正 App 签名时间
 * @param authCurrentTime 用于校正的时间戳，正整数。 
 * @details 不进行该操作，将以设备时间为准，为`(NSUInteger)[[NSDate date] timeIntervalSince1970]`。进行该操作后，如果有偏差，每次网络请求都会对设备时间进行矫正。
 * @attention 校正操作在 APP 的一个生命周期内生效，APP 重启后需要重新设置才能重新生效。可以重复设置。
 */
- (void)setAuthCurrentTime:(NSUInteger)authCurrentTime;

+ (instancetype)sharedInstance;

- (void)setCachedIPEnabled:(BOOL)enable;

- (void)setPreResolveHosts:(NSArray *)hosts;

- (NSString *)getIpByHostAsync:(NSString *)host;

- (NSArray *)getIpsByHostAsync:(NSString *)host;

- (NSString *)getIpByHostAsyncInURLFormat:(NSString *)host;

- (void)setHTTPSRequestEnabled:(BOOL)enable;

- (void)setExpiredIPEnabled:(BOOL)enable;

- (void)setLogEnabled:(BOOL)enable;

- (void)setPreResolveAfterNetworkChanged:(BOOL)enable;

@end

@interface HttpDnsService (HttpdnsDeprecated)

- (void)setAccountID:(int)accountID ALICLOUD_HTTPDNS_DEPRECATED("Deprecated in v1.5.2. Use -[HttpDnsService initWithAccountID:] instead.");

@end
