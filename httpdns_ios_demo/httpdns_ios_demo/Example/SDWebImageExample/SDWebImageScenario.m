//
//  SDWebImageScenario.m
//  httpdns_ios_demo
//
//  Created by wy on 2024/9/9.
//

#import "SDWebImageScenario.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import <SDWebImage/SDWebImage.h>
#import "HttpDnsNSURLProtocolImpl.h"
#import "ImageAlertView.h"

@implementation SDWebImageScenario

+ (void)httpDnsQueryWithURL:(NSString *)originalUrl {
    NSURL *url = [[NSURL alloc]initWithString:originalUrl];
    NSString *resolvedIpAddress = [self resolveAvailableIp:url.host];
    NSString *requestUrl = originalUrl;

    if (resolvedIpAddress) {
        // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
        requestUrl = [originalUrl stringByReplacingOccurrencesOfString:url.host withString:resolvedIpAddress];
        url = [[NSURL alloc]initWithString:requestUrl];
    }

    [self setupImageWithURL:url host:[[NSURL alloc]initWithString:originalUrl].host];
}

+ (void)setupImageWithURL:(NSURL *)url host:(NSString *)host {
    // 1. 设置自定义的 NSURLSessionConfiguration
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 为了处理SNI问题，这里替换了NSURLProtocol的实现
    NSMutableArray *protocolsArray = [NSMutableArray arrayWithArray:sessionConfiguration.protocolClasses];
    [protocolsArray insertObject:[HttpDnsNSURLProtocolImpl class] atIndex:0];
    [sessionConfiguration setProtocolClasses:protocolsArray];
    
    // 2. 配置 SDWebImageDownloaderConfig
    SDWebImageDownloaderConfig *downloaderConfig = [SDWebImageDownloaderConfig defaultDownloaderConfig];
    downloaderConfig.sessionConfiguration = sessionConfiguration;
    
    // 3. 创建 SDWebImageDownloader 并应用配置
    SDWebImageDownloader *downloader = [[SDWebImageDownloader alloc] initWithConfig:downloaderConfig];
    
    // 设置 requestModifier
    SDWebImageDownloaderRequestModifier *requestModifier = [SDWebImageDownloaderRequestModifier requestModifierWithBlock:^NSURLRequest * _Nullable(NSURLRequest * _Nonnull request) {
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        [mutableRequest setURL:url];
        [mutableRequest setValue:host forHTTPHeaderField:@"host"];
        return mutableRequest;
    }];
    downloader.requestModifier = requestModifier;
    
    // 4. 使用自定义的 Downloader 设置 SDWebImageManager
    SDWebImageManager *manager = [[SDWebImageManager alloc] initWithCache:[SDImageCache sharedImageCache] loader:downloader];
    
    // 5. 使用自定义的 SDWebImageManager
    [ImageAlertView imageAlertShow:^(UIImageView * _Nonnull imageView) {
        [imageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed context:@{SDWebImageContextCustomManager:manager}];
    }];
}

+ (NSString *)resolveAvailableIp:(NSString *)host {
    HttpDnsService *httpDnsService = [HttpDnsService sharedInstance];
    HttpdnsResult *result = [httpDnsService resolveHostSyncNonBlocking:host byIpType:HttpdnsQueryIPTypeAuto];

    NSLog(@"resolve host result: %@", result);
    if (!result) {
        return nil;
    }

    if (result.hasIpv4Address) {
        return result.firstIpv4Address;
    } else if (result.hasIpv6Address) {
        return [NSString stringWithFormat:@"[%@]", result.firstIpv6Address];
    } else {
        return nil;
    }
}


@end
