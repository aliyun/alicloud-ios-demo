#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EAPMDemoSecondaryPageHeaderView : UIView

- (instancetype)initWithTitle:(NSString *)title backHandler:(dispatch_block_t)backHandler;

@end

@interface EAPMDemoSectionHeaderView : UIView

- (void)configureWithTitle:(NSString *)title;

@end

@interface EAPMDemoTipCardView : UIView

- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor
                              textColor:(UIColor *)textColor
                            borderColor:(nullable UIColor *)borderColor;
- (void)configureWithText:(NSString *)text;
- (void)configureWithAttributedText:(NSAttributedString *)attributedText;

@end

@interface EAPMDemoInputFieldView : UIView

@property (nonatomic, strong, readonly) UITextField *textField;

- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
                     editable:(BOOL)editable;

@end

@interface EAPMDemoPrimaryButton : UIButton
@end

@interface EAPMDemoSecondaryActionButton : UIButton

- (void)configureWithTitle:(NSString *)title;
- (void)setActionHighlighted:(BOOL)highlighted;

@end

@interface EAPMDemoToastPresenter : NSObject

+ (void)showToastInViewController:(UIViewController *)presenter message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
