#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static const CGFloat EAPMDemoUIHorizontalInset = 16.0;
static const CGFloat EAPMDemoUIHeaderTopPadding = 10.0;
static const CGFloat EAPMDemoUIHeaderTitleSpacing = 4.0;
static const CGFloat EAPMDemoUIHeaderBottomPadding = 20.0;
static const CGFloat EAPMDemoUIContentTopSpacing = 4.0;
static const CGFloat EAPMDemoUISectionTopSpacing = 20.0;
static const CGFloat EAPMDemoUISectionContentSpacing = 14.0;
static const CGFloat EAPMDemoUIFieldSpacing = 6.0;
static const CGFloat EAPMDemoUIContentBottomPadding = 32.0;
static const CGFloat EAPMDemoUITipCardVerticalInset = 14.0;
static const CGFloat EAPMDemoUICornerRadius = 8.0;
static const CGFloat EAPMDemoUIInputHeight = 52.0;
static const CGFloat EAPMDemoUISecondaryActionHeight = 48.0;
static const CGFloat EAPMDemoUIPrimaryButtonHeight = 60.0;
static const CGFloat EAPMDemoUIAlertCornerRadius = 20.0;
static const CGFloat EAPMDemoUIAlertHorizontalInset = 20.0;
static const CGFloat EAPMDemoUIAlertTopInset = 20.0;
static const CGFloat EAPMDemoUIAlertTitleSpacing = 10.0;
static const CGFloat EAPMDemoUIAlertButtonTopSpacing = 18.0;
static const CGFloat EAPMDemoUIAlertButtonHeight = 52.0;
static const CGFloat EAPMDemoUIBottomSheetCornerRadius = 22.0;
static const CGFloat EAPMDemoUIBottomSheetHorizontalInset = 16.0;
static const CGFloat EAPMDemoUIBottomSheetTitleInset = 24.0;
static const CGFloat EAPMDemoUIBottomSheetStatusTopSpacing = 18.0;
static const CGFloat EAPMDemoUIBottomSheetStatusHeight = 40.0;
static const CGFloat EAPMDemoUIBottomSheetGuideTopSpacing = 20.0;
static const CGFloat EAPMDemoUIBottomSheetGuideSpacing = 16.0;
static const CGFloat EAPMDemoUIBottomSheetButtonTopSpacing = 28.0;

static inline UIColor *EAPMDemoUIColor(NSUInteger hexValue, CGFloat alpha) {
    return [UIColor colorWithRed:((hexValue >> 16) & 0xFF) / 255.0
                           green:((hexValue >> 8) & 0xFF) / 255.0
                            blue:(hexValue & 0xFF) / 255.0
                           alpha:alpha];
}

static inline UIFont *EAPMDemoUIFontRegular(CGFloat size) {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size] ?: [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
}

static inline UIFont *EAPMDemoUIFontMedium(CGFloat size) {
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size] ?: [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
}

static inline UIFont *EAPMDemoUIFontSemibold(CGFloat size) {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:size] ?: [UIFont systemFontOfSize:size weight:UIFontWeightSemibold];
}

static inline NSAttributedString *EAPMDemoPageTitleAttributedString(NSString *text, UIColor *textColor) {
    return [[NSAttributedString alloc] initWithString:text attributes:@{
        NSFontAttributeName: EAPMDemoUIFontMedium(22.0),
        NSForegroundColorAttributeName: textColor,
        NSKernAttributeName: @(0.8),
    }];
}

static inline NSAttributedString *EAPMDemoAlertTitleAttributedString(NSString *text, UIColor *textColor) {
    return [[NSAttributedString alloc] initWithString:text attributes:@{
        NSFontAttributeName: EAPMDemoUIFontSemibold(20.0),
        NSForegroundColorAttributeName: textColor,
    }];
}

static inline NSAttributedString *EAPMDemoBottomSheetTitleAttributedString(NSString *text, UIColor *textColor) {
    return [[NSAttributedString alloc] initWithString:text attributes:@{
        NSFontAttributeName: EAPMDemoUIFontMedium(20.0),
        NSForegroundColorAttributeName: textColor,
        NSKernAttributeName: @(0.4),
    }];
}

static inline NSAttributedString *EAPMDemoFieldTitleAttributedString(NSString *text, UIColor *textColor) {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = 24.0;
    paragraphStyle.maximumLineHeight = 24.0;
    return [[NSAttributedString alloc] initWithString:text attributes:@{
        NSFontAttributeName: EAPMDemoUIFontRegular(18.0),
        NSForegroundColorAttributeName: textColor,
        NSKernAttributeName: @(0.2),
        NSParagraphStyleAttributeName: paragraphStyle,
    }];
}

static inline NSAttributedString *EAPMDemoInfoAttributedString(NSString *text, UIColor *textColor) {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.minimumLineHeight = 20.0;
    paragraphStyle.maximumLineHeight = 20.0;
    return [[NSAttributedString alloc] initWithString:text attributes:@{
        NSFontAttributeName: EAPMDemoUIFontRegular(15.0),
        NSForegroundColorAttributeName: textColor,
        NSParagraphStyleAttributeName: paragraphStyle,
        NSKernAttributeName: @(0.2),
    }];
}

static inline NSAttributedString *EAPMDemoBodyAttributedString(NSString *text, UIColor *textColor) {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.minimumLineHeight = 24.0;
    paragraphStyle.maximumLineHeight = 24.0;
    return [[NSAttributedString alloc] initWithString:text attributes:@{
        NSFontAttributeName: EAPMDemoUIFontRegular(16.0),
        NSForegroundColorAttributeName: textColor,
        NSParagraphStyleAttributeName: paragraphStyle,
    }];
}

static inline NSAttributedString *EAPMDemoCenteredActionAttributedString(NSString *text, UIColor *textColor) {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.minimumLineHeight = 24.0;
    paragraphStyle.maximumLineHeight = 24.0;
    return [[NSAttributedString alloc] initWithString:text attributes:@{
        NSFontAttributeName: EAPMDemoUIFontRegular(16.0),
        NSForegroundColorAttributeName: textColor,
        NSParagraphStyleAttributeName: paragraphStyle,
    }];
}

static inline NSAttributedString *EAPMDemoAlertMessageAttributedString(NSString *text,
                                                                       UIColor *textColor,
                                                                       NSTextAlignment alignment) {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = alignment;
    paragraphStyle.minimumLineHeight = 24.0;
    paragraphStyle.maximumLineHeight = 24.0;
    return [[NSAttributedString alloc] initWithString:text attributes:@{
        NSFontAttributeName: EAPMDemoUIFontRegular(15.0),
        NSForegroundColorAttributeName: textColor,
        NSParagraphStyleAttributeName: paragraphStyle,
    }];
}

static inline UIView *EAPMDemoCreateSectionIndicatorView(UIColor *color) {
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    indicatorView.backgroundColor = color;
    indicatorView.layer.cornerRadius = 3.0;
    return indicatorView;
}

static inline void EAPMDemoConfigureSectionTitleLabel(UILabel *label, NSString *text, UIColor *textColor) {
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.textColor = textColor;
    label.font = EAPMDemoUIFontMedium(18.0);
}

static inline void EAPMDemoApplyTipCardStyle(UIView *view, UIColor *backgroundColor) {
    view.backgroundColor = backgroundColor;
    view.layer.cornerRadius = EAPMDemoUICornerRadius;
    view.layer.masksToBounds = YES;
}

static inline void EAPMDemoApplySecondaryCardStyle(UIView *view, UIColor *backgroundColor, UIColor *borderColor) {
    view.backgroundColor = backgroundColor;
    view.layer.cornerRadius = EAPMDemoUICornerRadius;
    view.layer.borderWidth = 2.0;
    view.layer.borderColor = borderColor.CGColor;
}

NS_ASSUME_NONNULL_END
