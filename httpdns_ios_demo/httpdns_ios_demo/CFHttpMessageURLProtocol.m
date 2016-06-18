//
//  MyCFHttpMessageURLProtocol.m
//  NSURLProtocolDemo
//
//  Created by fuyuan.lfy on 16/6/14.
//  Copyright © 2016年 Jaylon. All rights reserved.
//

#import "CFHttpMessageURLProtocol.h"
#import <AlicloudHttpDNS/Httpdns.h>
#import "NetworkManager.h"

#define protocolKey @"CFHttpMessagePropertyKey"
#define kAnchorAlreadyAdded @"AnchorAlreadyAdded"

@interface CFHttpMessageURLProtocol()<NSStreamDelegate,HttpDNSDegradationDelegate>{
    NSMutableData* responseData;
    NSMutableURLRequest* curRequest;
}

@property(strong,nonatomic)NSInputStream* inputStream;

@end

@implementation CFHttpMessageURLProtocol

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
    [self.client URLProtocol:self didFailWithError:[[NSError alloc] initWithDomain:@"stop loading" code:-1 userInfo:nil]];
}

/**
 *  使用CFHTTPMessage转发请求
 */
-(void)startRequest{
    //使用IP访问，必须在HTTP头部域设置host
    CFStringRef requestHeader=CFSTR("host");
    CFStringRef requestHeaderValue=(__bridge CFStringRef)[[curRequest allHTTPHeaderFields] valueForKey:@"host"];
    
    //添加http post请求所附带的数据
    CFStringRef requestBody=CFSTR("");
    CFDataRef bodyData=CFStringCreateExternalRepresentation(kCFAllocatorDefault, requestBody, kCFStringEncodingUTF8, 0);
    if (curRequest.HTTPBody) {
        bodyData=(__bridge_retained CFDataRef)curRequest.HTTPBody;
    }
//    CFDataRef bodyData=CFStringCreateExternalRepresentation(kCFAllocatorDefault, requestBody, kCFStringEncodingUTF8, 0);
    
    CFStringRef url=(__bridge CFStringRef)[curRequest.URL absoluteString];
    CFURLRef requestURL=CFURLCreateWithString(kCFAllocatorDefault, url, NULL);
    
    //原请求所使用的方法，GET或POST
    CFStringRef requestMethod=(__bridge_retained CFStringRef)curRequest.HTTPMethod;
    
    //根据请求的url、方法、版本创建CFHTTPMessageRef对象
    CFHTTPMessageRef cfrequest=CFHTTPMessageCreateRequest(kCFAllocatorDefault, requestMethod, requestURL, kCFHTTPVersion1_1);
    CFHTTPMessageSetBody(cfrequest, bodyData);
    CFHTTPMessageSetHeaderFieldValue(cfrequest, requestHeader, requestHeaderValue);
    
    //创建CFHTTPMessage对象的输入流，设置SSL验证参数
    CFReadStreamRef readStream=CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, cfrequest);
    self.inputStream=(__bridge_transfer NSInputStream*)readStream;
    
    //设置SNI host信息，关键步骤
    NSString* host=[curRequest.allHTTPHeaderFields objectForKey:@"host"];
    if (!host) {
        host=curRequest.URL.host;
    }
    [_inputStream setProperty:NSStreamSocketSecurityLevelNegotiatedSSL forKey:NSStreamSocketSecurityLevelKey];
    NSDictionary *sslProperties = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   host,(__bridge id)kCFStreamSSLPeerName,
                                   nil];
    [_inputStream setProperty:sslProperties forKey:(__bridge_transfer NSString*)kCFStreamPropertySSLSettings];
    [_inputStream setDelegate:self];
    
    //将请求放入当前runloop的事件队列
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_inputStream open];
    
    CFRelease(requestURL);
    CFRelease(cfrequest);
    CFRelease(requestBody);
}

/**
 *  根据服务器返回的响应内容进行不同的处理
 */
-(void)handleResponse{
    //获取响应头部信息
    CFReadStreamRef readStream = (__bridge_retained CFReadStreamRef)_inputStream;
    CFHTTPMessageRef message = (CFHTTPMessageRef)CFReadStreamCopyProperty(readStream, kCFStreamPropertyHTTPResponseHeader);
    NSDictionary* headDict = (__bridge NSDictionary *)(CFHTTPMessageCopyAllHeaderFields(message));
//    CFStringRef myStatusLine = CFHTTPMessageCopyResponseStatusLine(message);
    
    //获取响应头部的状态码
    CFIndex myErrCode = CFHTTPMessageGetResponseStatusCode(message);
    NSLog(@"response status code is: %ld",myErrCode);
    
    //把当前请求关闭
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_inputStream setDelegate:nil];
    [_inputStream close];
    
    if (myErrCode >= 200 && myErrCode < 300) {
        
        //返回码为2xx，直接通知client
        [self.client URLProtocol:self didLoadData:responseData];
        
    }else if(myErrCode>=300&&myErrCode<400){
        //返回码为3xx，需要重定向请求，继续访问重定向页面
        NSURLResponse* response=[[NSURLResponse alloc] initWithURL:curRequest.URL MIMEType:headDict[@"Content-Type"] expectedContentLength:[headDict[@"Content-Length"] integerValue] textEncodingName:@"UTF8"];
        [self.client URLProtocol:self wasRedirectedToRequest:curRequest redirectResponse:response];
        responseData=[NSMutableData data];
        // 为HTTPDNS服务设置降级机制
        [[HttpDnsService sharedInstance] setDelegateForDegradationFilter:(id<HttpDNSDegradationDelegate>)self];
        
        //获取重定向页面的url，并将url中的host通过HTTPDNS转换为IP
        NSString* location=headDict[@"Location"];
        NSURL* url=[[NSURL alloc] initWithString:location];
        NSString* ip=[[HttpDnsService sharedInstance] getIpByHost:url.host];
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
    }else{
        //其他情况，直接返回响应信息给client
        [self.client URLProtocol:self didLoadData:responseData];
    }
//    CFRelease(readStream);
//    CFRelease(message);
}

#pragma mark - NSStreamDelegate
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    if (eventCode==NSStreamEventHasSpaceAvailable||eventCode==NSStreamEventHasBytesAvailable) {
        //通知nsurlconnection已收到response
        CFReadStreamRef readStream=(__bridge_retained CFReadStreamRef)_inputStream;
        CFHTTPMessageRef message=(CFHTTPMessageRef)CFReadStreamCopyProperty(readStream, kCFStreamPropertyHTTPResponseHeader);
        NSDictionary* headDict=(__bridge NSDictionary *)(CFHTTPMessageCopyAllHeaderFields(message));
//        NSURLResponse* response = (__bridge_transfer NSURLResponse*)message;
        NSURLResponse* response=[[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:headDict[@"Content-Type"] expectedContentLength:[headDict[@"Content-Length"] integerValue] textEncodingName:@"UTF8"];
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        
        //验证证书
//        NSArray *certs = [_inputStream propertyForKey: (__bridge NSString *)kCFStreamPropertySSLPeerCertificates];
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
        //通知client发生错误了
        NSError *underlyingError = CFBridgingRelease(CFReadStreamCopyError((CFReadStreamRef)_inputStream));
        [self.client URLProtocol:self didFailWithError:underlyingError];
    }else if(eventCode==NSStreamEventEndEncountered){
        [self handleResponse];
    }
}

#pragma mark - HttpDNSDegradationDelegate
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
