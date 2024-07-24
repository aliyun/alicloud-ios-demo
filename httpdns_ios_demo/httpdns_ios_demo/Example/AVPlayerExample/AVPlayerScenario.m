//
//  AVPlayerScenario.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/24.
//

#import "AVPlayerScenario.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import <AVFoundation/AVFoundation.h>
#import "CustomResourceLoaderDelegate.h"
#import "AVPlayerAlertView.h"

@implementation AVPlayerScenario

+ (void)httpDnsQueryWithURL:(NSString *)originalUrl {
    NSURL *url = [[NSURL alloc]initWithString:originalUrl];
    NSString *resolvedIpAddress = [self resolveAvailableIp:url.host];
    NSString *requestUrl = originalUrl;

    if (resolvedIpAddress) {
        // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
        requestUrl = [originalUrl stringByReplacingOccurrencesOfString:url.host withString:resolvedIpAddress];
        url = [[NSURL alloc]initWithString:requestUrl];
    }

    [self setupAVPlayerWithURL:url host:[[NSURL alloc]initWithString:originalUrl].host];
}

+ (void)setupAVPlayerWithURL:(NSURL *)url host:(NSString *)host {
    // 替换URL Scheme以拦截请求
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    components.scheme = @"customScheme";
    NSURL *customURL = components.URL;

    // 创建 AVURLAsset 并使用自定义的 AVAssetResourceLoaderDelegate
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:customURL options:nil];
    CustomResourceLoaderDelegate *resourceLoaderDelegate = [[CustomResourceLoaderDelegate alloc]initWithHost:host Scheme:url.scheme];
    [asset.resourceLoader setDelegate:resourceLoaderDelegate queue:dispatch_get_main_queue()];

    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    // 设置播放的默认音量值
    player.volume = 1.0f;

    [AVPlayerAlertView avplayerAlertShow:player];
}

+ (NSString *)resolveAvailableIp:(NSString *)host {
    HttpDnsService *httpDnsService = [HttpDnsService sharedInstance];
    HttpdnsResult *result = [httpDnsService resolveHostSyncNonBlocking:host byIpType:HttpdnsQueryIPTypeBoth];

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
