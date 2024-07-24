//
//  CustomResourceLoaderDelegate.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/6/5.
//

#import "CustomResourceLoaderDelegate.h"
#import "HttpDnsNSURLProtocolImpl.h"

@interface CustomResourceLoaderDelegate()

@property(nonatomic, copy)NSString *host;
@property(nonatomic, copy)NSString *scheme;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation CustomResourceLoaderDelegate

-(instancetype)initWithHost:(NSString *)host Scheme:(NSString *)scheme {
    if (self = [super init]) {
        self.host = host;
        self.scheme = scheme;

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSMutableArray *protocolsArray = [NSMutableArray arrayWithArray:configuration.protocolClasses];
        [protocolsArray insertObject:[HttpDnsNSURLProtocolImpl class] atIndex:0];
        [configuration setProtocolClasses:protocolsArray];

        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    return self;
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    // 将请求的URL的Scheme换回原来的https
    NSString *originalURL = [self originalURLForCustomScheme:loadingRequest.request.URL];

    // 设置request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:originalURL]];
    [request setValue:self.host forHTTPHeaderField:@"host"];

    // 填写Range请求头
    if (loadingRequest.dataRequest.requestedOffset != 0) {
        NSString *range = [NSString stringWithFormat:@"bytes=%lld-", loadingRequest.dataRequest.requestedOffset];
        [request setValue:range forHTTPHeaderField:@"Range"];
    }

    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [loadingRequest finishLoadingWithError:error];
            return;
        }

        // 填充响应头
        loadingRequest.contentInformationRequest.contentType = response.MIMEType;
        loadingRequest.contentInformationRequest.contentLength = response.expectedContentLength;
        loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;

        // 填充数据
        [loadingRequest.dataRequest respondWithData:[self processingData:loadingRequest.dataRequest data:data]];
        [loadingRequest finishLoading];
    }];
    [dataTask resume];
    return YES;
}

- (NSData *)processingData:(AVAssetResourceLoadingDataRequest *)request data:(NSData *)data {
    NSInteger downloadedDataLength = data.length;

    long long requestRequestedOffset = request.requestedOffset;
    NSInteger requestRequestedLength = request.requestedLength;
    long long requestCurrentOffset = request.currentOffset;
    if (downloadedDataLength < requestCurrentOffset) {
        return nil;
    }

    NSInteger downloadedUnreadDataLength = downloadedDataLength - requestCurrentOffset;
    NSInteger requestUnreadDataLength = requestRequestedOffset + requestRequestedLength - requestCurrentOffset;
    NSInteger respondDataLength = MIN(requestUnreadDataLength, downloadedUnreadDataLength);

    NSData *responseData = [data subdataWithRange:NSMakeRange(requestCurrentOffset, respondDataLength)];
    return responseData;
}

// Helper method to switch the URL scheme back to https
- (NSString *)originalURLForCustomScheme:(NSURL *)url {
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    components.scheme = self.scheme;
    return components.URL.absoluteString;
}

@end
