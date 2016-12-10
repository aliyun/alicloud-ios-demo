//
//  WebViewPageRecorder.h
//  CFHTTPDNSRequest
//
//  Created by junmo on 16/12/10.
//  Copyright © 2016年 junmo. All rights reserved.
//

#ifndef WebViewPageRecorder_h
#define WebViewPageRecorder_h

@interface WebViewPageRecorder : NSObject

+ (void)putSwizzleRequest:(NSURLRequest *)swizzleRequest;
+ (NSString *)getResourceHostForIPInURL:(NSURL *)url;
+ (void)scanPageContent:(NSString *)host data:(NSData *)data response:(NSHTTPURLResponse *)response;
+ (void)clear;
+ (void)description;

@end

#endif /* WebViewPageRecorder_h */
