//
//  AddDomainAlertView.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AddHandle)(NSString *domain);

@interface AddDomainAlertView : UIView

@property(nonatomic, copy)AddHandle addHandle;

+ (void)alertWithTitle:(NSString *)title handle:(AddHandle)handle;

@end

NS_ASSUME_NONNULL_END
