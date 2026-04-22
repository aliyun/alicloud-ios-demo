#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EAPMDemoHomeViewController : UIViewController

@property (nonatomic, copy, nullable) NSString *launchBlockingAlertTitle;
@property (nonatomic, copy, nullable) NSString *launchBlockingAlertMessage;
@property (nonatomic, copy, nullable) dispatch_block_t launchBlockingAlertActionHandler;

@end

NS_ASSUME_NONNULL_END
