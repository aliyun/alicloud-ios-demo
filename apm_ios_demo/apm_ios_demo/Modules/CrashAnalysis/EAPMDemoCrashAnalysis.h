#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EAPMDemoHomeSectionModel;

@interface EAPMDemoCrashAnalysis : NSObject

+ (EAPMDemoHomeSectionModel *)sectionWithPresenter:(UIViewController *)presenter;

@end

NS_ASSUME_NONNULL_END
