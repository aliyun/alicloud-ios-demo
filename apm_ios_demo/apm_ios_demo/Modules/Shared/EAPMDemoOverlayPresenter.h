#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EAPMDemoAlertActionStyle) {
    EAPMDemoAlertActionStyleSecondary,
    EAPMDemoAlertActionStylePrimary,
};

typedef NS_ENUM(NSInteger, EAPMDemoAlertMessageAlignment) {
    EAPMDemoAlertMessageAlignmentCenter,
    EAPMDemoAlertMessageAlignmentLeft,
};

@interface EAPMDemoAlertAction : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, readonly) EAPMDemoAlertActionStyle style;
@property (nonatomic, copy, readonly, nullable) dispatch_block_t handler;

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(EAPMDemoAlertActionStyle)style
                        handler:(nullable dispatch_block_t)handler;

@end

@interface EAPMDemoAlertPresenter : NSObject

+ (void)presentAlertFrom:(UIViewController *)presenter
                   title:(NSString *)title
                 message:(NSString *)message
                 actions:(NSArray<EAPMDemoAlertAction *> *)actions;

+ (void)presentAlertFrom:(UIViewController *)presenter
                   title:(NSString *)title
                 message:(NSString *)message
        messageAlignment:(EAPMDemoAlertMessageAlignment)messageAlignment
                 actions:(NSArray<EAPMDemoAlertAction *> *)actions;

+ (void)presentAlertFrom:(UIViewController *)presenter
                   title:(NSString *)title
       attributedMessage:(NSAttributedString *)attributedMessage
                 actions:(NSArray<EAPMDemoAlertAction *> *)actions;

@end

@interface EAPMDemoBottomGuidePresenter : NSObject

+ (void)presentGuideFrom:(UIViewController *)presenter
                   title:(NSString *)title
              statusText:(NSString *)statusText
              guideItems:(NSArray<NSString *> *)guideItems;

@end

NS_ASSUME_NONNULL_END
