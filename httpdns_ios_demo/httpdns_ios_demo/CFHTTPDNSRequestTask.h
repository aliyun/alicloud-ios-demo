//
//  CFHTTPDNSRequestTask.h
//  CFHTTPDNSRequest
//
//  Created by junmo on 16/12/8.
//  Copyright © 2016年 junmo. All rights reserved.
//

#ifndef CFHTTPDNSRequestTask_h
#define CFHTTPDNSRequestTask_h

@protocol CFHTTPDNSRequestTaskDelegate;

@interface CFHTTPDNSRequestTask : NSObject

- (CFHTTPDNSRequestTask *)initWithURLRequest:(NSURLRequest *)request swizzleRequest:(NSURLRequest *)swizzleRequest delegate:(id<CFHTTPDNSRequestTaskDelegate>)delegate;
- (void)startLoading;
- (void)stopLoading;
- (NSString *)getOriginalRequestHost;
- (NSHTTPURLResponse *)getRequestResponse;

@end

#endif /* CFHTTPDNSRequestTask_h */
