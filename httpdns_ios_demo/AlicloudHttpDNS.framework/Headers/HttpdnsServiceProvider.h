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

@interface HttpDnsService: NSObject

@property (nonatomic, assign) int accountID;

@property (nonatomic, weak, setter=setDelegateForDegradationFilter:) id<HttpDNSDegradationDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)setPreResolveHosts:(NSArray *)hosts;

- (NSString *)getIpByHost:(NSString *)host;

- (NSArray *)getIpsByHost:(NSString *)host;

- (NSString *)getIpByHostInURLFormat:(NSString *)host;

- (NSString *)getIpByHostAsync:(NSString *)host;

- (NSArray *)getIpsByHostAsync:(NSString *)host;

- (NSString *)getIpByHostAsyncInURLFormat:(NSString *)host;

- (void)setHTTPSRequestEnabled:(BOOL)enable;

- (void)setExpiredIPEnabled:(BOOL)enable;

- (void)setLogEnabled:(BOOL)enable;

- (void)setPreResolveAfterNetworkChanged:(BOOL)enable;

@end
