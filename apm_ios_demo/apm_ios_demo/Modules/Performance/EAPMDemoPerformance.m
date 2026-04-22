#import "EAPMDemoPerformance.h"

#import "EAPMDemoHomeUI.h"
#import "../Shared/EAPMDemoOverlayPresenter.h"
#import "EAPMDemoNetworkAnalysisViewController.h"
#import "EAPMDemoPerformanceScrollViewController.h"

@implementation EAPMDemoPerformance

+ (NSAttributedString *)startupAnalysisMessage {
    UIColor *bodyColor = [UIColor colorWithRed:0x5B / 255.0 green:0x64 / 255.0 blue:0x72 / 255.0 alpha:1.0];
    UIColor *headingColor = [UIColor colorWithRed:0x2A / 255.0 green:0x2D / 255.0 blue:0x33 / 255.0 alpha:1.0];
    UIFont *bodyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15.0] ?: [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
    UIFont *headingFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:15.0] ?: [UIFont systemFontOfSize:15.0 weight:UIFontWeightSemibold];

    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] init];
    NSArray<NSArray<NSString *> *> *sections = @[
        @[@"冷启动", @"已在App启动时自动记录"],
        @[@"热启动", @"需将App进行前后台切换"],
        @[@"查看数据", @"所有启动数据均在App退至后台时统一上报，稍后可在 EMAS 控制台查看"],
    ];

    for (NSInteger index = 0; index < sections.count; index++) {
        NSArray<NSString *> *section = sections[index];
        [message appendAttributedString:[[NSAttributedString alloc] initWithString:section.firstObject attributes:@{
            NSFontAttributeName: headingFont,
            NSForegroundColorAttributeName: headingColor,
        }]];
        [message appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:@{
            NSFontAttributeName: bodyFont,
            NSForegroundColorAttributeName: bodyColor,
        }]];
        [message appendAttributedString:[[NSAttributedString alloc] initWithString:section.lastObject attributes:@{
            NSFontAttributeName: bodyFont,
            NSForegroundColorAttributeName: bodyColor,
        }]];
        if (index < sections.count - 1) {
            [message appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:@{
                NSFontAttributeName: bodyFont,
                NSForegroundColorAttributeName: bodyColor,
            }]];
        }
    }

    return message;
}

+ (EAPMDemoHomeSectionModel *)sectionWithPresenter:(UIViewController *)presenter {
    __weak UIViewController *weakPresenter = presenter;
    return [EAPMDemoHomeSectionModel sectionWithTitle:@"性能分析" items:@[
        [EAPMDemoHomeActionItem itemWithTitle:@"启动分析" actionHandler:^{
            [EAPMDemoAlertPresenter presentAlertFrom:weakPresenter
                                               title:@"启动分析"
                                   attributedMessage:[self startupAnalysisMessage]
                                             actions:@[
                [EAPMDemoAlertAction actionWithTitle:@"知道了"
                                               style:EAPMDemoAlertActionStylePrimary
                                             handler:nil],
            ]];
        }],
        [EAPMDemoHomeActionItem itemWithTitle:@"页面分析" actionHandler:^{
            EAPMDemoPerformanceScrollViewController *viewController = [[EAPMDemoPerformanceScrollViewController alloc] init];
            [weakPresenter.navigationController pushViewController:viewController animated:YES];
        }],
        [EAPMDemoHomeActionItem itemWithTitle:@"网络分析" actionHandler:^{
            EAPMDemoNetworkAnalysisViewController *viewController = [[EAPMDemoNetworkAnalysisViewController alloc] init];
            [weakPresenter.navigationController pushViewController:viewController animated:YES];
        }],
    ]];
}

@end
