//
//  CustomResourceLoaderDelegate.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/6/5.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomResourceLoaderDelegate : NSObject<AVAssetResourceLoaderDelegate, NSURLSessionTaskDelegate>
-(instancetype)initWithHost:(NSString *)host Scheme:(NSString *)scheme;
@end

NS_ASSUME_NONNULL_END
