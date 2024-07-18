//
//  ResolveFuctionViewController.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/12.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ResolveTypeSync,
    ResolveTypeAsync,
    ResolveTypeSyncNoBlocking,
} ResolveType;

NS_ASSUME_NONNULL_BEGIN

@interface ResolveFuctionViewController : UIViewController

- (void)resolveHost:(NSString *)host type:(ResolveType)resolveType;
@end

NS_ASSUME_NONNULL_END
