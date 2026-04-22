#import "EAPMDemoHomeUI.h"
#import "../Shared/EAPMDemoUIComponents.h"
#import "../Shared/EAPMDemoUIStyleGuide.h"

static UIColor *EAPMDemoColorHex(NSUInteger hexValue, CGFloat alpha) {
    return [UIColor colorWithRed:((hexValue >> 16) & 0xFF) / 255.0
                           green:((hexValue >> 8) & 0xFF) / 255.0
                            blue:(hexValue & 0xFF) / 255.0
                           alpha:alpha];
}

@interface EAPMDemoHomeActionItem ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) EAPMDemoHomeActionHandler actionHandler;

@end

@implementation EAPMDemoHomeActionItem

+ (instancetype)itemWithTitle:(NSString *)title actionHandler:(EAPMDemoHomeActionHandler)actionHandler {
    EAPMDemoHomeActionItem *item = [[self alloc] init];
    item.title = title;
    item.actionHandler = actionHandler;
    return item;
}

- (void)performAction {
    if (self.actionHandler) {
        self.actionHandler();
    }
}

@end

@interface EAPMDemoHomeSectionModel ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSArray<EAPMDemoHomeActionItem *> *items;

@end

@implementation EAPMDemoHomeSectionModel

+ (instancetype)sectionWithTitle:(NSString *)title items:(NSArray<EAPMDemoHomeActionItem *> *)items {
    EAPMDemoHomeSectionModel *section = [[self alloc] init];
    section.title = title;
    section.items = items;
    return section;
}

@end

@interface EAPMDemoGradientBackgroundView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation EAPMDemoGradientBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = EAPMDemoColorHex(0xF3F4F8, 1.0);
        self.clipsToBounds = YES;

        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eapm_home_bg"]];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        _backgroundImageView.alpha = 0.15;
        [self addSubview:_backgroundImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat scale = CGRectGetWidth(self.bounds) / 375.0;
    self.backgroundImageView.frame = CGRectMake(-283.89 * scale,
                                                0.0,
                                                1160.89 * scale,
                                                653.0 * scale);
}

@end

@interface EAPMDemoHeroHeaderView ()

@property (nonatomic, strong) UIImageView *heroImageView;
@property (nonatomic, strong) NSLayoutConstraint *heroImageHeightConstraint;
@property (nonatomic, strong) EAPMDemoTipCardView *infoBannerView;
@property (nonatomic, strong) UIView *bottomGradientView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UILabel *settingsLabel;
@property (nonatomic, strong) UIButton *settingsTapButton;
@property (nonatomic, copy) EAPMDemoHomeActionHandler settingsHandler;

@end

@implementation EAPMDemoHeroHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildViews];
    }
    return self;
}

- (void)buildViews {
    self.clipsToBounds = YES;

    _heroImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eapm_home_hero"]];
    _heroImageView.contentMode = UIViewContentModeScaleAspectFit;

    _bottomGradientView = [[UIView alloc] init];
    CAGradientLayer *bottomLayer = [CAGradientLayer layer];
    bottomLayer.colors = @[
        (__bridge id)[UIColor colorWithWhite:1 alpha:0.0].CGColor,
        (__bridge id)EAPMDemoColorHex(0xF3F4F8, 1.0).CGColor,
    ];
    bottomLayer.startPoint = CGPointMake(0.5, 0.0);
    bottomLayer.endPoint = CGPointMake(0.5, 1.0);
    [_bottomGradientView.layer addSublayer:bottomLayer];

    _infoBannerView = [[EAPMDemoTipCardView alloc] initWithBackgroundColor:EAPMDemoColorHex(0xEBF0FF, 1.0)
                                                                 textColor:EAPMDemoColorHex(0x7087AD, 1.0)
                                                               borderColor:EAPMDemoColorHex(0xD9E4FB, 1.0)];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"移动监控 Demo";
    _titleLabel.textColor = EAPMDemoColorHex(0x4B4D52, 1.0);
    _titleLabel.font = EAPMDemoUIFontMedium(22.0);
    _titleLabel.numberOfLines = 1;

    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.text = @"欢迎来到阿里云移动监控 Demo，开始你的调试吧~";
    _subtitleLabel.textColor = EAPMDemoColorHex(0x607B9C, 1.0);
    _subtitleLabel.numberOfLines = 2;
    _subtitleLabel.attributedText = EAPMDemoInfoAttributedString(@"欢迎来到阿里云移动监控 Demo，开始你的调试吧~",
                                                                 EAPMDemoColorHex(0x607B9C, 1.0));

    _settingsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _settingsButton.backgroundColor = UIColor.clearColor;
    _settingsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    if (@available(iOS 13.0, *)) {
        UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:15.0 weight:UIImageSymbolWeightRegular];
        UIImage *image = [UIImage systemImageNamed:@"gearshape" withConfiguration:configuration];
        [_settingsButton setImage:image forState:UIControlStateNormal];
        _settingsButton.tintColor = EAPMDemoColorHex(0x5D6573, 1.0);
    } else {
        [_settingsButton setTitle:@"⚙︎" forState:UIControlStateNormal];
        [_settingsButton setTitleColor:EAPMDemoColorHex(0x5D6573, 1.0) forState:UIControlStateNormal];
        _settingsButton.titleLabel.font = EAPMDemoUIFontRegular(15.0);
    }
    _settingsLabel = [[UILabel alloc] init];
    _settingsLabel.textColor = EAPMDemoColorHex(0x394153, 1.0);
    _settingsLabel.font = EAPMDemoUIFontRegular(15.0);
    NSMutableAttributedString *settingsText = [[NSMutableAttributedString alloc] initWithString:@"设置" attributes:@{
        NSFontAttributeName: _settingsLabel.font,
        NSForegroundColorAttributeName: EAPMDemoColorHex(0x394153, 1.0),
        NSKernAttributeName: @(1.2),
    }];
    _settingsLabel.attributedText = settingsText;

    _settingsTapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingsTapButton.backgroundColor = UIColor.clearColor;
    [_settingsTapButton addTarget:self action:@selector(handleSettingsTapped) forControlEvents:UIControlEventTouchUpInside];

    for (UIView *view in @[_heroImageView, _bottomGradientView, _infoBannerView, _titleLabel, _subtitleLabel, _settingsButton, _settingsLabel, _settingsTapButton]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
    }
    [self bringSubviewToFront:_settingsButton];
    [self bringSubviewToFront:_settingsLabel];
    [self bringSubviewToFront:_settingsTapButton];

    _heroImageHeightConstraint = [_heroImageView.heightAnchor constraintEqualToConstant:266.0];

    [NSLayoutConstraint activateConstraints:@[
        [_heroImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_heroImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_heroImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        _heroImageHeightConstraint,

        [_titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0],
        [_titleLabel.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:58.0],
        [_titleLabel.widthAnchor constraintEqualToConstant:220.0],

        [_subtitleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0],
        [_subtitleLabel.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:12.0],
        [_subtitleLabel.widthAnchor constraintEqualToConstant:208.0],

        [_settingsButton.trailingAnchor constraintEqualToAnchor:_settingsLabel.leadingAnchor constant:-3.0],
        [_settingsButton.centerYAnchor constraintEqualToAnchor:_settingsLabel.centerYAnchor constant:-2.0],
        [_settingsButton.widthAnchor constraintEqualToConstant:18.0],
        [_settingsButton.heightAnchor constraintEqualToConstant:18.0],

        [_settingsLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16.0],
        [_settingsLabel.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:-4.0],

        [_settingsTapButton.leadingAnchor constraintEqualToAnchor:_settingsButton.leadingAnchor constant:-6.0],
        [_settingsTapButton.trailingAnchor constraintEqualToAnchor:_settingsLabel.trailingAnchor constant:6.0],
        [_settingsTapButton.topAnchor constraintEqualToAnchor:_settingsLabel.topAnchor constant:-6.0],
        [_settingsTapButton.bottomAnchor constraintEqualToAnchor:_settingsLabel.bottomAnchor constant:6.0],

        [_infoBannerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16.0],
        [_infoBannerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16.0],
        [_infoBannerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

        [_bottomGradientView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_bottomGradientView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_bottomGradientView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [_bottomGradientView.heightAnchor constraintEqualToConstant:24.0],
    ]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imageHeight = CGRectGetWidth(self.bounds) * 1068.0 / 1500.0;
    self.heroImageHeightConstraint.constant = ceil(imageHeight);

    CALayer *layer = self.bottomGradientView.layer.sublayers.firstObject;
    layer.frame = self.bottomGradientView.bounds;
}

- (void)configureWithInfoText:(NSString *)text settingsHandler:(nullable EAPMDemoHomeActionHandler)settingsHandler {
    self.settingsHandler = settingsHandler;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:EAPMDemoInfoAttributedString(text, EAPMDemoColorHex(0x7087AD, 1.0))];
    NSRange highlightRange = [text rangeOfString:@"EMAS 控制台"];
    if (highlightRange.location != NSNotFound) {
        [attributedText addAttributes:@{
            NSFontAttributeName: EAPMDemoUIFontSemibold(15.0),
            NSForegroundColorAttributeName: EAPMDemoColorHex(0x374254, 1.0),
        } range:highlightRange];
    }
    [self.infoBannerView configureWithAttributedText:attributedText];
    self.settingsTapButton.enabled = (settingsHandler != nil);
}

- (void)handleSettingsTapped {
    if (self.settingsHandler) {
        self.settingsHandler();
    }
}

@end
