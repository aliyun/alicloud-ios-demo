//
//  MyCFHttpMessageURLProtocol.m
//  NSURLProtocolDemo
//
//  Created by fuyuan.lfy on 16/6/14.
//  Copyright © 2016年 Jaylon. All rights reserved.
//

#import "MyCFHttpMessageURLProtocol.h"
#import "HttpDNS.h"
#import "HttpDNSLog.h"
#import "NetworkManager.h"

#define protocolKey @"CFHttpMessagePropertyKey"
#define kAnchorAlreadyAdded @"AnchorAlreadyAdded"

@interface MyCFHttpMessageURLProtocol()<NSStreamDelegate>{
    NSMutableData* responseData;
    NSMutableURLRequest* curRequest;
}

@property(strong,nonatomic)NSInputStream* inputStream;

@end

@implementation MyCFHttpMessageURLProtocol

/**
 *  是否拦截处理指定的请求
 *
 *  @param request 指定的请求
 *
 *  @return 返回YES表示要拦截处理，返回NO表示不拦截处理
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    /*
     防止无限循环，因为一个请求在被拦截处理过程中，也会发起一个请求，这样又会走到这里，如果不进行处理，就会造成无限循环
     */
    if ([NSURLProtocol propertyForKey:protocolKey inRequest:request]) {
        return NO;
    }
    
    NSString * url = request.URL.absoluteString;
    
    // 如果url已http或https开头，则进行拦截处理，否则不处理
    if ([url hasPrefix:@"https"]) {
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
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

-(void)startRequest{
    CFStringRef requestHeader=CFSTR("host");
    CFStringRef requestHeaderValue=(__bridge CFStringRef)[[curRequest allHTTPHeaderFields] valueForKey:@"host"];
    CFStringRef requestBody=CFSTR("");
    CFDataRef bodyData=CFStringCreateExternalRepresentation(kCFAllocatorDefault, requestBody, kCFStringEncodingUTF8, 0);
    
    CFStringRef url=(__bridge CFStringRef)[curRequest.URL absoluteString];
    CFStringRef requestMethod=(__bridge_retained CFStringRef)curRequest.HTTPMethod;
    CFURLRef requestURL=CFURLCreateWithString(kCFAllocatorDefault, url, NULL);
    CFHTTPMessageRef cfrequest=CFHTTPMessageCreateRequest(kCFAllocatorDefault, requestMethod, requestURL, kCFHTTPVersion1_1);
    CFHTTPMessageSetBody(cfrequest, bodyData);
    CFHTTPMessageSetHeaderFieldValue(cfrequest, requestHeader, requestHeaderValue);
    
    CFReadStreamRef readStream=CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, cfrequest);
    self.inputStream=(__bridge_transfer NSInputStream*)readStream;
    NSString* host=[curRequest.allHTTPHeaderFields objectForKey:@"host"];
    if (!host) {
        host=curRequest.URL.host;
    }
    [_inputStream setProperty:NSStreamSocketSecurityLevelNegotiatedSSL forKey:NSStreamSocketSecurityLevelKey];
    //    CFReadStreamSetProperty(readStream, (CFStringRef)NSStreamSocketSecurityLevelKey, kCFStreamSocketSecurityLevelNegotiatedSSL);
    NSDictionary *sslProperties = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //                                   (id)kCFBooleanFalse, (id)kCFStreamSSLValidatesCertificateChain,
                                   host,(__bridge id)kCFStreamSSLPeerName,
                                   nil];
    [_inputStream setProperty:sslProperties forKey:(__bridge_transfer NSString*)kCFStreamPropertySSLSettings];
    [_inputStream setDelegate:self];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_inputStream open];
    
    CFRelease(requestURL);
    CFRelease(cfrequest);
    CFRelease(requestBody);
}
/**
 *  开始加载，在该方法中，加载一个请求
 */
- (void)startLoading {
    NSMutableURLRequest * request = [self.request mutableCopy];
    // 表示该请求已经被处理，防止无限循环
    [NSURLProtocol setProperty:@(YES) forKey:protocolKey inRequest:request];
    curRequest=request;
    [self startRequest];
}
/**
 *  取消请求
 */
- (void)stopLoading {
    
}

-(void)handleResponse{
    CFReadStreamRef readStream=(__bridge_retained CFReadStreamRef)_inputStream;
    CFHTTPMessageRef message=(CFHTTPMessageRef)CFReadStreamCopyProperty(readStream, kCFStreamPropertyHTTPResponseHeader);
    NSDictionary* headDict=(__bridge NSDictionary *)(CFHTTPMessageCopyAllHeaderFields(message));
//    NSLog(@"response header is: %@",headDict[@"Location"]);
    CFStringRef myStatusLine = CFHTTPMessageCopyResponseStatusLine(message);
//    NSLog(@"response status line is: %@",myStatusLine);
    CFIndex myErrCode = CFHTTPMessageGetResponseStatusCode(message);
    NSLog(@"response status code is: %ld",myErrCode);
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_inputStream setDelegate:nil];
    [_inputStream close];
    if (myErrCode>=200&&myErrCode<300) {
        [self.client URLProtocol:self didLoadData:responseData];
    }else if(myErrCode>=300&&myErrCode<400){
        //重定向
        responseData=[NSMutableData data];
        // 为HTTPDNS服务设置降级机制
        [[HttpDNS instance] setDelegateForDegradationFilter:(id<HttpDNSDegradationDelegate>)self];
        NSString* location=headDict[@"Location"];
        NSURL* url=[[NSURL alloc] initWithString:location];
        NSString* ip=[[HttpDNS instance] getIpByHost:url.host];
        curRequest=[[NSMutableURLRequest alloc] initWithURL:url];
        if (ip) {
            NSLog(@"Get IP from HTTPDNS Successfully!");
            NSRange hostFirstRange = [location rangeOfString: url.host];
            if (NSNotFound != hostFirstRange.location) {
                NSString* newUrl = [location stringByReplacingCharactersInRange:hostFirstRange withString:ip];
                curRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
                [curRequest setValue:url.host forHTTPHeaderField:@"host"];
            }
        }
        [self startRequest];
    }
//    NSLog(@"response is: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
}

#pragma mark - NSStreamDelegate
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    if (eventCode==NSStreamEventHasSpaceAvailable||eventCode==NSStreamEventHasBytesAvailable) {
        //通知nsurlconnection已收到response
        CFReadStreamRef readStream=(__bridge_retained CFReadStreamRef)_inputStream;
        CFHTTPMessageRef message=(CFHTTPMessageRef)CFReadStreamCopyProperty(readStream, kCFStreamPropertyHTTPResponseHeader);
        NSDictionary* headDict=(__bridge NSDictionary *)(CFHTTPMessageCopyAllHeaderFields(message));
        NSURLResponse* response=[[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:headDict[@"Content-Type"] expectedContentLength:headDict[@"Content-Length"] textEncodingName:@"UTF8"];
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        
        //验证证书
        NSArray *certs = [_inputStream propertyForKey: (__bridge NSString *)kCFStreamPropertySSLPeerCertificates];
        SecTrustRef trust = (__bridge SecTrustRef)[_inputStream propertyForKey: (__bridge NSString *)kCFStreamPropertySSLPeerTrust];
        NSNumber *alreadyAdded = [_inputStream propertyForKey: kAnchorAlreadyAdded];
        if (!alreadyAdded || ![alreadyAdded boolValue]) {
            [_inputStream setProperty: [NSNumber numberWithBool: YES] forKey: kAnchorAlreadyAdded];
        }
        SecTrustResultType res = kSecTrustResultInvalid;
//        NSMutableArray *policies = [NSMutableArray array];
//        NSString* domain=[[self.request allHTTPHeaderFields] valueForKey:@"host"];
//        if (domain) {
//            [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)domain)];
//        } else {
//            [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
//        }
        /*
         * 绑定校验策略到服务端的证书上
         */
//        SecTrustSetPolicies(trust, (__bridge CFArrayRef)policies);
        if (SecTrustEvaluate(trust, &res)!= errSecSuccess) {
            [_inputStream removeFromRunLoop: [NSRunLoop currentRunLoop] forMode: NSRunLoopCommonModes];
            [_inputStream setDelegate: nil];
            [_inputStream close];
        }
        if (res != kSecTrustResultProceed && res != kSecTrustResultUnspecified) {
            /* The host is not trusted. */
            /* Tear down the input stream. */
            [_inputStream removeFromRunLoop: [NSRunLoop currentRunLoop] forMode: NSRunLoopCommonModes];
            [_inputStream setDelegate: nil];
            [_inputStream close];
            
            /* Tear down the output stream. */
            
            
        } else {
            // Host is trusted.  Handle the data callback normally.
            if (!responseData) {
                responseData=[NSMutableData data];
            }
            UInt8 buffer[2048];
            //回调读取数据时，读取的都是body的内容，response header自动被封装处理好的。
            NSInputStream* inputstream=(NSInputStream*)aStream;
            CFIndex length = [inputstream read:buffer maxLength:sizeof(buffer)];
            [responseData appendBytes:buffer length:length];
        }
    }else if(eventCode==NSStreamEventErrorOccurred){
        [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_inputStream setDelegate:nil];
        [_inputStream close];
        NSError *underlyingError = CFBridgingRelease(CFReadStreamCopyError((CFReadStreamRef)_inputStream));
        [self.client URLProtocol:self didFailWithError:underlyingError];
    }else if(eventCode==NSStreamEventEndEncountered){
        [self handleResponse];
    }
}
/*
 * 降级过滤器，您可以自己定义HTTPDNS降级机制
 */
- (BOOL)shouldDegradeHTTPDNS:(NSString *)hostName {
    NSLog(@"Enters Degradation filter.");
    // 根据HTTPDNS使用说明，存在网络代理情况下需降级为Local DNS
    if ([NetworkManager configureProxies]) {
        NSLog(@"Proxy was set. Degrade!");
        return YES;
    }
    
    // 假设您禁止"www.taobao.com"域名通过HTTPDNS进行解析
    if ([hostName isEqualToString:@"www.taobao.com"]) {
        NSLog(@"The host is in blacklist. Degrade!");
        return YES;
    }
    
    return NO;
}

@end
