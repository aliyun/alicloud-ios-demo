//
//  WebViewURLProtocol.m
//  httpdns_ios_demo
//
//  Created by fuyuan.lfy on 16/6/25.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "WebViewURLProtocol.h"
#import <AlicloudHttpDNS/Httpdns.h>
#import <objc/runtime.h>

#define protocolKey @"CFHttpMessagePropertyKey"
#define kAnchorAlreadyAdded @"AnchorAlreadyAdded"

@interface WebViewURLProtocol () <NSStreamDelegate>

@end

@implementation WebViewURLProtocol
/**
 *  是否拦截处理指定的请求
 *
 *  @param request 指定的请求
 *
 *  @return 返回YES表示要拦截处理，返回NO表示不拦截处理
 */
+ (BOOL)canInitWithRequest:(NSURLRequest*)request {

    /* 防止无限循环，因为一个请求在被拦截处理过程中，也会发起一个请求，这样又会走到这里，如果不进行处理，就会造成无限循环 */
    if ([NSURLProtocol propertyForKey:protocolKey inRequest:request]) {
        return NO;
    }

    NSMutableURLRequest* mutableReq = [request mutableCopy];

    // 假设原始的请求头部没有host信息，只有使用IP替换后的请求才有
    NSString* host = [mutableReq valueForHTTPHeaderField:@"host"];

    // 假设只拦截原始请求中css的请求
    if (mutableReq && !host && [[mutableReq.HTTPMethod lowercaseString] isEqualToString:@"get"] && [mutableReq.URL.absoluteString hasSuffix:@".css"]) {
        return YES;
    }
    return NO;
}

/**
 *  如果需要对请求进行重定向，添加指定头部等操作，可以在该方法中进行
 *
 *  @param request 原请求
 *
 *  @return 修改后的请求
 */
+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)request {
    NSMutableURLRequest* mutableReq = [request mutableCopy];
    NSString* originalUrl = mutableReq.URL.absoluteString;
    NSURL* url = [NSURL URLWithString:originalUrl];
    // 同步接口获取IP地址，由于我们是用来进行url访问请求的，为了适配IPv6的使用场景，我们使用getIpByHostInURLFormat接口
    NSString* ip = [[HttpDnsService sharedInstance] getIpByHostAsync:url.host];
    if (ip) {
        // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
        NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", ip, url.host);
        NSRange hostFirstRange = [originalUrl rangeOfString:url.host];
        if (NSNotFound != hostFirstRange.location) {
            NSString* newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
            NSLog(@"New URL: %@", newUrl);
            mutableReq = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
            [mutableReq setValue:url.host forHTTPHeaderField:@"host"];
            // 添加originalUrl保存原始URL
            [mutableReq addValue:originalUrl forHTTPHeaderField:@"originalUrl"];
        }
    }
    return [mutableReq copy];
}
/**
 *  开始加载，在该方法中，加载一个请求
 */
- (void)startLoading {
    NSMutableURLRequest* request = [self.request mutableCopy];
    // 表示该请求已经被处理，防止无限循环
    [NSURLProtocol setProperty:@(YES) forKey:protocolKey inRequest:request];
    [self startRequest];
}
/**
 *  取消请求
 */
- (void)stopLoading {
}

/**
 *  使用CFHTTPMessage转发请求
 */
- (void)startRequest {
    // 添加http post请求所附带的数据
    CFStringRef requestBody = CFSTR("");
    CFDataRef bodyData = CFStringCreateExternalRepresentation(kCFAllocatorDefault, requestBody, kCFStringEncodingUTF8, 0);
    if (self.request.HTTPBody) {
        bodyData = (__bridge_retained CFDataRef) self.request.HTTPBody;
    }

    CFStringRef url = (__bridge CFStringRef)[self.request.URL absoluteString];
    CFURLRef requestURL = CFURLCreateWithString(kCFAllocatorDefault, url, NULL);

    // 原请求所使用的方法，GET或POST
    CFStringRef requestMethod = (__bridge_retained CFStringRef) self.request.HTTPMethod;

    // 根据请求的url、方法、版本创建CFHTTPMessageRef对象
    CFHTTPMessageRef cfrequest = CFHTTPMessageCreateRequest(kCFAllocatorDefault, requestMethod, requestURL, kCFHTTPVersion1_1);
    CFHTTPMessageSetBody(cfrequest, bodyData);

    // copy原请求的header信息
    NSDictionary* headFields = self.request.allHTTPHeaderFields;
    for (NSString* header in headFields) {
        CFStringRef requestHeader = (__bridge CFStringRef) header;
        CFStringRef requestHeaderValue = (__bridge CFStringRef) [headFields valueForKey:header];
        CFHTTPMessageSetHeaderFieldValue(cfrequest, requestHeader, requestHeaderValue);
    }

    // 创建CFHTTPMessage对象的输入流，设置SSL验证参数
    CFReadStreamRef readStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, cfrequest);
    NSInputStream* inputStream = (__bridge_transfer NSInputStream*) readStream;

    // 设置SNI host信息，关键步骤
    NSString* host = [self.request.allHTTPHeaderFields objectForKey:@"host"];
    if (!host) {
        host = self.request.URL.host;
    }

    if ([self.request.URL.absoluteString hasPrefix:@"https"]) {
        // https请求设置证书
        [inputStream setProperty:NSStreamSocketSecurityLevelNegotiatedSSL forKey:NSStreamSocketSecurityLevelKey];
        NSDictionary* sslProperties = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                host, (__bridge id) kCFStreamSSLPeerName,
                                                            (id) kCFBooleanFalse, (id) kCFStreamSSLValidatesCertificateChain,
                                                            nil];
        [inputStream setProperty:sslProperties forKey:(__bridge_transfer NSString*) kCFStreamPropertySSLSettings];
    }
    [inputStream setDelegate:self];

    // 将请求放入当前runloop的事件队列
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [inputStream open];

    CFRelease(requestURL);
    CFRelease(cfrequest);
    CFRelease(requestBody);
}

/**
 *  根据服务器返回的响应内容进行不同的处理
 */
- (void)handleResponse:(NSInputStream*)inputStream {
    // 获取响应头部信息
    CFReadStreamRef readStream = (__bridge_retained CFReadStreamRef) inputStream;
    CFHTTPMessageRef message = (CFHTTPMessageRef) CFReadStreamCopyProperty(readStream, kCFStreamPropertyHTTPResponseHeader);
    NSDictionary* headDict = (__bridge NSDictionary*) (CFHTTPMessageCopyAllHeaderFields(message));

    // 获取响应头部的状态码
    CFIndex myErrCode = CFHTTPMessageGetResponseStatusCode(message);

    // 把当前请求关闭
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [inputStream setDelegate:nil];
    [inputStream close];

    if (myErrCode >= 200 && myErrCode < 300) {
        // 返回码为2xx，直接通知client
        [self.client URLProtocolDidFinishLoading:self];
    } else if (myErrCode >= 300 && myErrCode < 400) {
        // 返回码为3xx，需要重定向请求，继续访问重定向页面
        NSString* location = headDict[@"Location"];
        NSURL* url = [[NSURL alloc] initWithString:location];
        NSMutableURLRequest* newRequest = [[NSMutableURLRequest alloc] initWithURL:url];

        /***********重定向通知client处理*************/
        CFStringRef httpVersion = CFHTTPMessageCopyVersion(message);
        NSURLResponse* response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL statusCode:myErrCode HTTPVersion:(__bridge NSString*) httpVersion headerFields:headDict];
        [self.client URLProtocol:self wasRedirectedToRequest:newRequest redirectResponse:response];
    } else {
        // 其他情况，直接返回响应信息给client
        [self.client URLProtocolDidFinishLoading:self];
    }
}

#pragma mark - NSStreamDelegate
/**
 * input stream 收到数据后的回调函数
 */
- (void)stream:(NSStream*)aStream handleEvent:(NSStreamEvent)eventCode {
    if (eventCode == NSStreamEventHasSpaceAvailable || eventCode == NSStreamEventHasBytesAvailable) {
        UInt8 buffer[2048];
        NSInputStream* inputstream = (NSInputStream*) aStream;
        NSNumber* alreadyAdded = objc_getAssociatedObject(aStream, kAnchorAlreadyAdded);
        if (!alreadyAdded || ![alreadyAdded boolValue]) {
            objc_setAssociatedObject(aStream, kAnchorAlreadyAdded, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_COPY);
            // 通知client已收到response，且只通知一次
            CFReadStreamRef readStream = (__bridge_retained CFReadStreamRef) aStream;
            CFHTTPMessageRef message = (CFHTTPMessageRef) CFReadStreamCopyProperty(readStream, kCFStreamPropertyHTTPResponseHeader);
            NSDictionary* headDict = (__bridge NSDictionary*) (CFHTTPMessageCopyAllHeaderFields(message));
            CFStringRef httpVersion = CFHTTPMessageCopyVersion(message);
            // 获取响应头部的状态码
            CFIndex myErrCode = CFHTTPMessageGetResponseStatusCode(message);
            // 此处返回的Response中的URL必须是原始的URL，不然会影响WebView后续请求
            NSHTTPURLResponse* response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:[self.request.allHTTPHeaderFields valueForKey:@"originalUrl"]] statusCode:myErrCode HTTPVersion:(__bridge NSString*) httpVersion headerFields:headDict];
            [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];

            if ([self.request.URL.absoluteString hasPrefix:@"https"]) {
                // 验证证书
                SecTrustRef trust = (__bridge SecTrustRef) [aStream propertyForKey:(__bridge NSString*) kCFStreamPropertySSLPeerTrust];

                SecTrustResultType res = kSecTrustResultInvalid;
                NSMutableArray* policies = [NSMutableArray array];
                NSString* domain = [[self.request allHTTPHeaderFields] valueForKey:@"host"];
                if (domain) {
                    [policies addObject:(__bridge_transfer id) SecPolicyCreateSSL(true, (__bridge CFStringRef) domain)];
                } else {
                    [policies addObject:(__bridge_transfer id) SecPolicyCreateBasicX509()];
                }

                // 绑定校验策略到服务端的证书上
                SecTrustSetPolicies(trust, (__bridge CFArrayRef) policies);
                if (SecTrustEvaluate(trust, &res) != errSecSuccess) {
                    [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
                    [aStream setDelegate:nil];
                    [aStream close];
                }
                if (res != kSecTrustResultProceed && res != kSecTrustResultUnspecified) {
                    /* 证书验证不通过，关闭input stream */
                    [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
                    [aStream setDelegate:nil];
                    [aStream close];
                } else {
                    // 证书通过，读取数据
                    CFIndex length = [inputstream read:buffer maxLength:sizeof(buffer)];
                    NSData* data = [[NSData alloc] initWithBytes:buffer length:length];

                    [self.client URLProtocol:self didLoadData:data];
                }
            } else {
                // http请求
                CFIndex length = [inputstream read:buffer maxLength:sizeof(buffer)];
                NSData* data = [[NSData alloc] initWithBytes:buffer length:length];

                [self.client URLProtocol:self didLoadData:data];
            }
        } else {
            CFIndex length = [inputstream read:buffer maxLength:sizeof(buffer)];
            NSData* data = [[NSData alloc] initWithBytes:buffer length:length];

            [self.client URLProtocol:self didLoadData:data];
        }
    } else if (eventCode == NSStreamEventErrorOccurred) {
        [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [aStream setDelegate:nil];
        [aStream close];
        // 通知client发生错误了
        NSError* underlyingError = CFBridgingRelease(CFReadStreamCopyError((CFReadStreamRef)(NSInputStream*) aStream));
        [self.client URLProtocol:self didFailWithError:underlyingError];
    } else if (eventCode == NSStreamEventEndEncountered) {
        [self handleResponse:(NSInputStream*) aStream];
    }
}

@end
