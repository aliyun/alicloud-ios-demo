//
//  AppDelegate.m
//  TestPublicYunUpdate
//
//  Created by ASP on 2020/5/28.
//  Copyright © 2020 ASP. All rights reserved.
//

#import "AppDelegate.h"

#import <AlicloudUpdate/AlicloudUpdate.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    EMASConfigService *config = [EMASConfigService shareInstance];
    //私有云环境读取的plist文件和公有云环境的plist文件内容不一样，要手动配置appkey和appSecret。
    //公共云可以从plist配置中自动读取，如果没有plist配置文件，也要手动配置。
//    config.appKey = @"20000005";
//    config.appSecret = @"cda1ca43ce2eabda2ee0c8bd8aed069d";
    
    AlicloudUpdateCenter *updateCenter = [AlicloudUpdateCenter shareInstance];
    /*下面环境信息配置二选一*/
    //公共云默认生产环境，客户无需设置。接口供内部调试使用
//    updateCenter.requestHost = ReleaseEnvironment;
    //私有化环境这里配置域名信息，每个客户不一样，注意修改。1.0.0.6以上版本才有此接口。
//    [updateCenter setPrivateCloudEnvironmentWithUrlHeader:@"https或http" domain:@"emas-poc.com"];
    
    //调用版本更新推送接口
    [AlicloudUpdate autoInit];
    
    //不调用updateViewCallback，走默认更新弹框
    __weak typeof(updateCenter) weakUpdateCenter = updateCenter;
    updateCenter.updateViewCallback = ^(AlicloudUpdateModel * _Nonnull updateModel) {
        NSString *updateMsg = [NSString stringWithFormat:@"%@ \n 更新包大小：%@", updateModel.info, updateModel.size];

        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:updateMsg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakUpdateCenter clickUpdateButton];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:ok];
        if (weakUpdateCenter.updateStrategy) {
            [alertVc addAction:cancel];
        }
        //[self.window.rootViewController presentViewController:alertVc animated:YES completion:nil];//Scene App时，方法不弹提示框
        [[UIApplication sharedApplication].windows.firstObject.rootViewController presentViewController:alertVc animated:YES completion:nil];
    };
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
