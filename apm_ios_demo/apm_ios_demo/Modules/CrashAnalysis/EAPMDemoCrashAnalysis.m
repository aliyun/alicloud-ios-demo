#import "EAPMDemoCrashAnalysis.h"

#import "EAPMDemoHomeUI.h"
#import "../Shared/EAPMDemoOverlayPresenter.h"
#import "../Shared/EAPMDemoUIComponents.h"
#import "EAPMDemoCrashViewController.h"
#import <AlicloudApmCrashAnalysis/AlicloudApmCrashAnalysis.h>

static void EAPMDemoPresentConfirmAlert(UIViewController *presenter, NSString *title, NSString *message, dispatch_block_t confirmHandler) {
    if (!presenter || presenter.presentedViewController) {
        return;
    }

    [EAPMDemoAlertPresenter presentAlertFrom:presenter
                                       title:title
                                     message:message
                                     actions:@[
        [EAPMDemoAlertAction actionWithTitle:@"取消"
                                       style:EAPMDemoAlertActionStyleSecondary
                                         handler:nil],
        [EAPMDemoAlertAction actionWithTitle:@"确定"
                                       style:EAPMDemoAlertActionStylePrimary
                                         handler:confirmHandler],
    ]];
}

@implementation EAPMDemoCrashAnalysis

+ (EAPMDemoHomeSectionModel *)sectionWithPresenter:(UIViewController *)presenter {
    __weak UIViewController *weakPresenter = presenter;
    return [EAPMDemoHomeSectionModel sectionWithTitle:@"崩溃分析" items:@[
        [EAPMDemoHomeActionItem itemWithTitle:@"崩溃" actionHandler:^{
            EAPMDemoPresentConfirmAlert(weakPresenter,
                                        @"崩溃",
                                        @"即将触发崩溃，App将闪退，稍后可在 EMAS 控制台看到崩溃信息。",
                                        ^{
                NSArray *array = @[];
                NSLog(@"%@", array[1]);
            });
        }],
        [EAPMDemoHomeActionItem itemWithTitle:@"卡顿" actionHandler:^{
            EAPMDemoPresentConfirmAlert(weakPresenter,
                                        @"卡顿",
                                        @"即将触发应用「卡顿」，卡顿结束后，请切换至后台触发上报，稍后可在 EMAS 控制台看到卡顿信息。",
                                        ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [EAPMDemoToastPresenter showToastInViewController:weakPresenter message:@"卡顿结束"];
                });
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSThread sleepForTimeInterval:6];
                });
            });
        }],
        [EAPMDemoHomeActionItem itemWithTitle:@"自定义异常" actionHandler:^{
            EAPMCrashAnalysis *crashAnalysis = [EAPMCrashAnalysis crashAnalysis];
            for (NSInteger index = 0; index < 8; index++) {
                [crashAnalysis setCustomValue:[NSString stringWithFormat:@"customValue-%ld", (long)index + 1]
                                       forKey:@"configCustomInfoWithKey"];
                NSError *error = [NSError errorWithDomain:@"customError"
                                                     code:10001 + index
                                                 userInfo:@{
                                                     @"errorInfoKey": [NSString stringWithFormat:@"errorInfoValue-%ld", (long)index + 1],
                                                     @"errorScene": @"home_custom_exception",
                                                 }];
                [crashAnalysis recordError:error];
            }
            if (!weakPresenter || weakPresenter.presentedViewController) {
                return;
            }

            [EAPMDemoAlertPresenter presentAlertFrom:weakPresenter
                                               title:@"自定义异常"
                                             message:@"已触发多条自定义异常，请在 EMAS 控制台查看自定义异常详情"
                                             actions:@[
                [EAPMDemoAlertAction actionWithTitle:@"知道了"
                                               style:EAPMDemoAlertActionStylePrimary
                                             handler:nil],
            ]];
        }],
        [EAPMDemoHomeActionItem itemWithTitle:@"其它类型崩溃" actionHandler:^{
            if (!weakPresenter.navigationController) {
                return;
            }

            EAPMDemoCrashViewController *viewController = [[EAPMDemoCrashViewController alloc] init];
            [weakPresenter.navigationController pushViewController:viewController animated:YES];
        }],
    ]];
}

@end
