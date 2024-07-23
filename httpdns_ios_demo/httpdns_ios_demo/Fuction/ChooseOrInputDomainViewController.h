//
//  ChooseOrInputHostViewController.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/12.
//

#import <UIKit/UIKit.h>

@protocol ChooseOrInputDomainDelegate <NSObject>

- (void)domainResult:(NSString *_Nullable)domain isInput:(BOOL)isInput;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ChooseOrInputDomainViewController : UIViewController

@property(nonatomic, weak) id<ChooseOrInputDomainDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
