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
 *  记录WebView页面Host、HTTPDNS解析得到IP、页面加载资源列表
 *  基于HTTPS加载相对路径资源时，根据输入IP映射到Host
 *
 *  为防止同一IP对应多个域名，`resourcesArrayOnPage`记录页面加载资源列表：js、css、html...
 *  示例代码中仅对CSS文件做了处理，通过输入IP查找对应页面Host时，
 *  可在其关联的`resourcesArrayOnPage`中查找是否包含该资源
 *  例：
 *  载入`https://a.b.com/test.css`时，HTTPDNS解析得到IP`1.2.3.4`
 *  创建一项`WebViewPageRecordItem`记录，
 *  - itemA
 *      - pageIPAddress: 1.2.3.4
 *      - pageHost: a.b.com
 *      - resourceArrayOnPage: nil
 *  替换请求为`https://1.2.3.4/test.css`，该css文件加载完成，扫描得到需加载相对路径`../asset/xx`的资源文件
 *  更新item记录
 *  - itemA
 *      - pageIPAddress: 1.2.3.4
 *      - pageHost: a.b.com
 *      - resourceArrayOnPage: [(../asset/xx)]
 *  WebView重新发起请求加载该相对路径资源，请求为`https://1.2.3.4/nn/asset/xx`，此时Host丢失无法通过HTTPS的SSL/TLS校验
 *  以IP地址`1.2.3.4`为Key，匹配item记录，找到itemA
 *  查找itemA记录中是否有`nn/asset/xx`的记录，匹配到`../asset/xx`，确认此次加载资源是从该页面发起的请求
 *  返回对应的host，`a.b.com`，填充到request头部的`host`字段，即可通过HTTPS的证书校验，请求到该相对路径资源
 *  **********************【注意】*********************************
 *  确认同一IP仅对应单一域名的场景，只需记录IP到Host的映射即可；
 *  特殊场景下，本CSS文件匹配策略仅作为示例提供，不建议直接使用。
 *  **********************【注意】*********************************
 */
@interface WebViewPageRecordItem : NSObject

@property (nonatomic, copy) NSString *pageIPAddress;        // 页面解析IP结果
@property (nonatomic, copy) NSString *pageHost;             // 页面Host
@property (nonatomic, copy) NSArray *resourcesArrayOnPage;  // 页面加载资源列表

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
    NSString *relativePath = url.relativePath;
    NSLog(@"Relative path is: %@.", relativePath);
    for (WebViewPageRecordItem *item in pageRecordArr) {
        if ([item.pageIPAddress isEqualToString:ip]) {
            /*
             *  校验相对路径是否在资源列表记录中
             */
//            if ([self urlPathInResourcesArryOnPage:relativePath WebViewResourceItem:item]) {
//                host = item.pageHost;
//                break;
//            }
            host = item.pageHost;
            break;
        }
    }
    return host;
}

/**
 *  示例：扫描CSS文件中要加载的资源列表（不建议直接使用）
 */
+ (void)scanPageContent:(NSString *)host data:(NSData *)data response:(NSHTTPURLResponse *)response {
    NSString *contentType = [response.allHeaderFields objectForKey:@"Content-Type"];
    NSString *analyseIP = response.URL.host;
    // 处理CSS文件
    if ([contentType isEqualToString:@"text/css"]) {
        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *urls = [self CSSURLsFromString:content];
        WebViewPageRecordItem *item = [self searchItem:analyseIP];
        if (item && [item.pageHost isEqualToString:host]) {
            item.resourcesArrayOnPage = urls;
        }
    }
}

/**
 *  清空记录
 */
+ (void)clear {
    if (pageRecordArr) {
        [pageRecordArr removeAllObjects];
    }
}

/**
 *  查找CSS文件中的URL列表
 */
+ (NSArray *)CSSURLsFromString:(NSString *)string {
    NSMutableArray *urls = [NSMutableArray array];
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCaseSensitive:NO];
    while (1) {
        NSString *theURL = nil;
        [scanner scanUpToString:@"url(" intoString:NULL];
        [scanner scanString:@"url(" intoString:NULL];
        [scanner scanUpToString:@")" intoString:&theURL];
        if (!theURL) {
            break;
        }
        theURL = [theURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        theURL = [theURL stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\"'"]];
        theURL = [theURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [urls addObject:theURL];
    }
    return urls;
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

+ (BOOL)urlPathInResourcesArryOnPage:(NSString *)path WebViewResourceItem:(WebViewPageRecordItem *)item {
    NSString *separator = @"/";
    NSString *replaceStr = @"..";
    NSArray *segArray = [path componentsSeparatedByString:separator];
    NSMutableArray *strArray = [NSMutableArray array];
    unsigned long index = segArray.count - 1;
    int i = 0;
    while (index) {
        NSString *seg = [segArray objectAtIndex:index];
        if (seg && seg.length > 0) {
            if (i == 0) {
                [strArray addObject:seg];
            } else {
                [strArray addObject:[NSString stringWithFormat:@"%@/%@", [segArray objectAtIndex:index], [strArray objectAtIndex:i-1]]];
            }
            i++;
        }
        index--;
    }
    
    for (int i = 0; i < strArray.count; i++) {
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", replaceStr, [strArray objectAtIndex:i]];
        [strArray replaceObjectAtIndex:i withObject:fullPath];
    }
    
    for (NSString *str in item.resourcesArrayOnPage) {
        for (long i = strArray.count - 1; i >= 0; i--) {
            if ([str containsString:[strArray objectAtIndex:i]]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (void)description {
    NSLog(@"WebViewResourceRecord Array is:");
    for (WebViewPageRecordItem *item in pageRecordArr) {
        NSLog(@"IP: [%@] - Host: [%@] - PageContent: [%@]", item.pageIPAddress, item.pageHost, item.resourcesArrayOnPage);
    }
}

@end
