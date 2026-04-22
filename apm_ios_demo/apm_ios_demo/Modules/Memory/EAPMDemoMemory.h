#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EAPMDemoHomeSectionModel;

@interface EAPMDemoMemory : NSObject

+ (EAPMDemoHomeSectionModel *)sectionWithPresenter:(UIViewController *)presenter;

@end

NS_ASSUME_NONNULL_END
