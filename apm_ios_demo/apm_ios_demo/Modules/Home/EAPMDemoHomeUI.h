#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^EAPMDemoHomeActionHandler)(void);

@interface EAPMDemoHomeActionItem : NSObject

@property (nonatomic, copy, readonly) NSString *title;

+ (instancetype)itemWithTitle:(NSString *)title actionHandler:(EAPMDemoHomeActionHandler)actionHandler;
- (void)performAction;

@end

@interface EAPMDemoHomeSectionModel : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSArray<EAPMDemoHomeActionItem *> *items;

+ (instancetype)sectionWithTitle:(NSString *)title items:(NSArray<EAPMDemoHomeActionItem *> *)items;

@end

@interface EAPMDemoGradientBackgroundView : UIView

@end

@interface EAPMDemoHeroHeaderView : UIView

- (void)configureWithInfoText:(NSString *)text settingsHandler:(nullable EAPMDemoHomeActionHandler)settingsHandler;

@end

NS_ASSUME_NONNULL_END
