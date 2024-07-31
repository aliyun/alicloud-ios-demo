//
//  SettingDomainListViewController.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PreResolveDomainList,
    CleanCacheDomainList,
} DomainListType;

@interface SettingDomainListViewController : UIViewController

@property(nonatomic, assign)DomainListType listType;

@end

NS_ASSUME_NONNULL_END
