//
//  WebViewPageRecorder.m
//  CFHTTPDNSRequest
//
//  Created by junmo on 16/12/10.
//  Copyright © 2016年 junmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewPageRecorder.h"

/**
 *  记录加载WebView资源时HTTPDNS解析IP和Host映射关系；
 *  基于HTTPS加载相对路径资源时，根据输入IP映射到Host。
 *
 *  例：
 *  载入`https://a.b.com/c/d/test.css`时，HTTPDNS解析得到IP`1.2.3.4`
 *  创建一项`WebViewPageRecordItem`记录，
 *  - itemA
 *      - pageIPAddress: 1.2.3.4
 *      - pageHost: a.b.com
 *  替换请求为`https://1.2.3.4/ccc/dddd/test.css`，请求Header `host`字段填充为`a.b.com`，发起网络请求获取资源；
 *
 *  若该CSS文件需要加载相对路径资源`../asset/xx`
 *  WebView重新发起请求加载该相对路径资源，请求为`https://1.2.3.4/ccc/asset/xx`，此时Host丢失无法通过HTTPS的SSL/TLS校验
 *
 *  以IP地址`1.2.3.4`为Key，查找解析IP和Host映射，找到itemA
 *  返回对应的host，`a.b.com`，填充到请求Header `host`字段，即可通过HTTPS的证书校验，请求到该相对路径资源。
 *  **********************【注意】*********************************
 *  该映射和匹配规则适用于解析IP和域名Host一一对应的场景。
 *  **********************【注意】*********************************
 */
@interface WebViewPageRecordItem : NSObject

@property (nonatomic, copy) NSString *pageIPAddress;        // HTTPDNS解析IP
@property (nonatomic, copy) NSString *pageHost;             // Host

@end

@implementation WebViewPageRecordItem
@end

static NSMutableArray *pageRecordArr;

/**
 *  `pageRecordArr`中每一项存储`WebViewPageRecordItem`
 */
@implementation WebViewPageRecorder

+ (void)initialize {
    if (pageRecordArr == nil) {
        pageRecordArr = [NSMutableArray array];
    }
}

/**
 *  HTTPDNS解析域名替换Request后调用
 *  记录解析IP和Host的映射
 */
+ (void)putSwizzleRequest:(NSURLRequest *)swizzleRequest {
    
    if (!swizzleRequest) {
        return;
    }
    
    NSString *ipString = swizzleRequest.URL.host;
    NSString *originalHost = swizzleRequest.allHTTPHeaderFields[@"host"];
    
    [self setResourceItem:ipString host:originalHost];
}

/**
 *  由URL中的IP地址找到对应Host记录
 */
+ (NSString *)getResourceHostForIPInURL:(NSURL *)url {
    NSString *ip = url.host;
    NSString *host = nil;
    for (WebViewPageRecordItem *item in pageRecordArr) {
        if ([item.pageIPAddress isEqualToString:ip]) {
            host = item.pageHost;
            break;
        }
    }
    return host;
}

/**
 *  清空记录
 */
+ (void)clear {
    if (pageRecordArr) {
        [pageRecordArr removeAllObjects];
    }
}

+ (void)setResourceItem:(NSString *)ip host:(NSString *)host {
    
    WebViewPageRecordItem *item = [self searchItem:ip];
    if (item) {
        item.pageHost = host;
        return;
    }
    item = [[WebViewPageRecordItem alloc] init];
    item.pageIPAddress = ip;
    item.pageHost = host;
    [pageRecordArr addObject:item];
}

+ (WebViewPageRecordItem *)searchItem:(NSString *)ip {
    for (int i = 0; i < pageRecordArr.count; i++) {
        WebViewPageRecordItem *item = (WebViewPageRecordItem *) [pageRecordArr objectAtIndex:i];
        if ([item.pageIPAddress isEqualToString:ip]) {
            return item;
        }
    }
    return nil;
}

+ (void)description {
    NSLog(@"WebViewResourceRecord Array is:");
    for (WebViewPageRecordItem *item in pageRecordArr) {
        NSLog(@"IP: [%@] - Host: [%@].", item.pageIPAddress, item.pageHost);
    }
}

@end
