#import "EAPMDemoRemoteLog.h"

#import "EAPMDemoHomeUI.h"
#import "../Shared/EAPMDemoOverlayPresenter.h"
#import <AlicloudApmRemoteLog/AlicloudApmRemoteLog.h>

@implementation EAPMDemoRemoteLog

+ (EAPMDemoHomeSectionModel *)sectionWithPresenter:(UIViewController *)presenter {
    __weak UIViewController *weakPresenter = presenter;
    return [EAPMDemoHomeSectionModel sectionWithTitle:@"远程日志" items:@[
        [EAPMDemoHomeActionItem itemWithTitle:@"日志回捞" actionHandler:^{
            EAPMRemoteLog *remoteLogger = [[EAPMRemoteLog alloc] initWithModuleName:@"YourModuleName"];
            [remoteLogger error:@"error message"];
            [remoteLogger warn:@"warn message"];
            [remoteLogger debug:@"debug message"];
            [remoteLogger info:@"info message"];
            [EAPMDemoBottomGuidePresenter presentGuideFrom:weakPresenter
                                                     title:@"日志回捞"
                                                statusText:@"打日志成功"
                                                guideItems:@[
                @"在 EMAS 控制台「远程日志」模块，根据当前设备，创建回捞任务",
                @"Demo App 切换前后台上报日志",
                @"等待1-2分钟，在控制台查看日志",
            ]];
        }],
        [EAPMDemoHomeActionItem itemWithTitle:@"主动上报" actionHandler:^{
            EAPMRemoteLog *remoteLogger = [[EAPMRemoteLog alloc] initWithModuleName:@"YourModuleName"];
            [remoteLogger error:@"主动上报日志内容"];
            [EAPMRemoteLog uploadTLog:@"主动上报bizComment"];
            [EAPMDemoBottomGuidePresenter presentGuideFrom:weakPresenter
                                                     title:@"主动上报"
                                                statusText:@"打日志成功"
                                                guideItems:@[
                @"等待1-2分钟，在 EMAS 控制台「远程日志」模块查看日志",
            ]];
        }],
    ]];
}

@end
