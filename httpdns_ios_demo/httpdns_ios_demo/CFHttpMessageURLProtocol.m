
//  MyCFHttpMessageURLProtocol.m
//  NSURLProtocolDemo
//
//  Created by fuyuan.lfy on 16/6/14.
//  Copyright © 2016年 Jaylon. All rights reserved.
//

#import "CFHttpMessageURLProtocol.h"
#import "NetworkManager.h"
#import <AlicloudHttpDNS/Httpdns.h>
#import <objc/runtime.h>

#define protocolKey @"CFHttpMessagePropertyKey"
#define kAnchorAlreadyAdded @"AnchorAlreadyAdded"

@interface CFHttpMessageURLProtocol () <NSStreamDelegate> {
    NSMutableURLRequest* curRequest;
}

@end

@implementation CFHttpMessageURLProtocol

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

    NSString* url = request.URL.absoluteString;

    // 如果url以https开头，则进行拦截处理，否则不处理
    if ([url hasPrefix:@"https"]) {
        return YES;
    }
    return NO;
}

/**
 * 如果需要对请求进行重定向，添加指定头部等操作，可以在该方法中进行
 */
+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)request {
    return request;
}

/**
 * 开始加载，在该方法中，加载一个请求
 */
- (void)startLoading {
    NSMutableURLRequest* request = [self.request mutableCopy];
    // 表示该请求已经被处理，防止无限循环
    [NSURLProtocol setProperty:@(YES) forKey:protocolKey inRequest:request];
    curRequest = request;
    [self startRequest];
}

/**
 * 取消请求
 */
- (void)stopLoading {
    [self.client URLProtocol:self didFailWithError:[[NSError alloc] initWithDomain:@"stop loading" code:-1 userInfo:nil]];
}

/**
 * 使用CFHTTPMessage转发请求
 */
- (void)startRequest {
    // 添加http post请求所附带的数据
    CFStringRef requestBody = CFSTR("");
    CFDataRef bodyData = CFStringCreateExternalRepresentation(kCFAllocatorDefault, requestBody, kCFStringEncodingUTF8, 0);
    if (curRequest.HTTPBody) {
        bodyData = (__bridge_retained CFDataRef) curRequest.HTTPBody;
    }

    CFStringRef url = (__bridge CFStringRef)[curRequest.URL absoluteString];
    CFURLRef requestURL = CFURLCreateWithString(kCFAllocatorDefault, url, NULL);

    // 原请求所使用的方法，GET或POST
    CFStringRef requestMethod = (__bridge_retained CFStringRef) curRequest.HTTPMethod;

    // 根据请求的url、方法、版本创建CFHTTPMessageRef对象
    CFHTTPMessageRef cfrequest = CFHTTPMessageCreateRequest(kCFAllocatorDefault, requestMethod, requestURL, kCFHTTPVersion1_1);
    CFHTTPMessageSetBody(cfrequest, bodyData);

    // copy原请求的header信息
    NSDictionary* headFields = curRequest.allHTTPHeaderFields;
    for (NSString* header in headFields) {
        CFStringRef requestHeader = (__bridge CFStringRef) header;
        CFStringRef requestHeaderValue = (__bridge CFStringRef) [headFields valueForKey:header];
        CFHTTPMessageSetHeaderFieldValue(cfrequest, requestHeader, requestHeaderValue);
    }

    // 创建CFHTTPMessage对象的输入流，设置SSL验证参数
    CFReadStreamRef readStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, cfrequest);
    NSInputStream* inputStream = (__bridge_transfer NSInputStream*) readStream;

    // 设置SNI host信息，关键步骤
    NSString* host = [curRequest.allHTTPHeaderFields objectForKey:@"host"];
    if (!host) {
        host = curRequest.URL.host;
    }
    [inputStream setProperty:NSStreamSocketSecurityLevelNegotiatedSSL forKey:NSStreamSocketSecurityLevelKey];
    NSDictionary* sslProperties = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                            host, (__bridge id) kCFStreamSSLPeerName,
                                                        nil];
    [inputStream setProperty:sslProperties forKey:(__bridge_transfer NSString*) kCFStreamPropertySSLSettings];
    [inputStream setDelegate:self];

    // 将请求放入当前runloop的事件队列
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [inputStream open];

    CFRelease(requestURL);
    CFRelease(cfrequest);
    CFRelease(requestBody);
}

/**
 * 根据服务器返回的响应内容进行不同的处理
 */
- (void)handleResponseWithInputStream:(NSStream*)inputStream {
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
        curRequest = [[NSMutableURLRequest alloc] initWithURL:url];

        /***********重定向通知client处理或内部处理*************/
        // client处理
        // NSURLResponse* response = [[NSURLResponse alloc] initWithURL:curRequest.URL MIMEType:headDict[@"Content-Type"] expectedContentLength:[headDict[@"Content-Length"] integerValue] textEncodingName:@"UTF8"];
        // [self.client URLProtocol:self wasRedirectedToRequest:curRequest redirectResponse:response];

        // 内部处理，将url中的host通过HTTPDNS转换为IP
        NSString* ip = [[HttpDnsService sharedInstance] getIpByHost:url.host];

        if (ip) {
            NSLog(@"Get IP from HTTPDNS Successfully!");
            NSRange hostFirstRange = [location rangeOfString:url.host];
            if (NSNotFound != hostFirstRange.location) {
                NSString* newUrl = [location stringByReplacingCharactersInRange:hostFirstRange withString:ip];
                curRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
                [curRequest setValue:url.host forHTTPHeaderField:@"host"];
            }
        }
        [self startRequest];
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
            [_inputStream setProperty: [NSNumber numberWithBool: YES] forKey: kAnchorAlreadyAdded];
        }
        SecTrustResultType res = kSecTrustResultInvalid;
        NSMutableArray *policies = [NSMutableArray array];
        NSString* domain = [[curRequest allHTTPHeaderFields] valueForKey:@"host"];
        if (domain) {
            [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)domain)];
        } else {
            [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
        }
        /*
         * 绑定校验策略到服务端的证书上
         */
        SecTrustSetPolicies(trust, (__bridge CFArrayRef)policies);
        if (SecTrustEvaluate(trust, &res) != errSecSuccess) {
            [_inputStream removeFromRunLoop: [NSRunLoop currentRunLoop] forMode: NSRunLoopCommonModes];
            [_inputStream setDelegate: nil];
            [_inputStream close];
            [self.client URLProtocol:self didFailWithError:[[NSError alloc] initWithDomain:@"can not evaluate the server trust" code:-1 userInfo:nil]];
        }
        if (res != kSecTrustResultProceed && res != kSecTrustResultUnspecified) {
            /* 证书验证不通过，关闭input stream */
            [_inputStream removeFromRunLoop: [NSRunLoop currentRunLoop] forMode: NSRunLoopCommonModes];
            [_inputStream setDelegate: nil];
            [_inputStream close];
            [self.client URLProtocol:self didFailWithError:[[NSError alloc] initWithDomain:@"fail to evaluate the server trust" code:-1 userInfo:nil]];
            
        } else {
            // 证书已验证过，返回数据
            CFIndex length = [inputstream read:buffer maxLength:sizeof(buffer)];
            NSData* data = [[NSData alloc] initWithBytes:buffer length:length];
            [self.client URLProtocol:self didLoadData:data];
        }

    } else if (eventCode == NSStreamEventErrorOccurred) {
        [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [aStream setDelegate:nil];
        [aStream close];
        // 通知client发生错误了
        NSError* underlyingError = CFBridgingRelease(CFReadStreamCopyError((__bridge_retained CFReadStreamRef) aStream));
        [self.client URLProtocol:self didFailWithError:underlyingError];
    } else if (eventCode == NSStreamEventEndEncountered) {
        [self handleResponseWithInputStream:aStream];
    }
}

@end
