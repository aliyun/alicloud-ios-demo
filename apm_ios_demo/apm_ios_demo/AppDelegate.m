//
//  AppDelegate.m
//  apm_ios_demo
//
//  Created by sky on 2019/10/11.
//  Copyright © 2019 aliyun. All rights reserved.
//

#import "AppDelegate.h"

#import "EAPMDemoConfigStore.h"
#import "EAPMDemoHomeViewController.h"
#import <AlicloudApmCore/AlicloudApmCore.h>
#import <AlicloudApmCrashAnalysis/AlicloudApmCrashAnalysis.h>
#import <AlicloudApmPerformance/AlicloudApmPerformance.h>
#import <AlicloudApmRemoteLog/AlicloudApmRemoteLog.h>
#import <AlicloudApmMemAlloc/AlicloudApmMemAlloc.h>
#import <AlicloudApmMemLeak/AlicloudApmMemLeak.h>

// 请前往 EMAS 控制台获取应用配置，在此替换。
static NSString * const EAPMDemoAPMAppKey = @"";
static NSString * const EAPMDemoAPMAppSecret = @"";
static NSString * const EAPMDemoAPMAppRsaSecret = @"";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 打印沙盒路径
     NSLog(@"App Directory: %@", NSHomeDirectory());

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self installMainInterface];

    if (![self canStartApmSDK]) {
        [self configureLaunchBlockingAlertOnHomeInterface];
        return YES;
    }

    // 启动 Alicloud APM SDK
    [self startApmSDK];

    return YES;
}

- (void)installMainInterface {
    EAPMDemoHomeViewController *homeViewController = [[EAPMDemoHomeViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    navigationController.navigationBar.prefersLargeTitles = NO;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
}

- (BOOL)canStartApmSDK {
    return [self isConfiguredValue:EAPMDemoAPMAppKey] &&
           [self isConfiguredValue:EAPMDemoAPMAppSecret] &&
           [self isConfiguredValue:EAPMDemoAPMAppRsaSecret];
}

- (void)startApmSDK {
    NSString *appKey = [self normalizedConfigValue:EAPMDemoAPMAppKey];
    NSString *appSecret = [self normalizedConfigValue:EAPMDemoAPMAppSecret];
    NSString *appRsaSecret = [self normalizedConfigValue:EAPMDemoAPMAppRsaSecret];
    NSArray *functions = @[[EAPMCrashAnalysis class],
                           [EAPMPerformance class],
                           [EAPMRemoteLog class],
                           [EAPMMemAlloc class],
                           [EAPMMemLeak class]];

    EAPMOptions *options = [[EAPMOptions alloc] initWithAppKey:appKey
                                                     appSecret:appSecret];

    options.userId = [EAPMDemoConfigStore storedUserId];
    options.userNick = [EAPMDemoConfigStore storedUserNick];
    options.channel = @"dev";
    options.appRsaSecret = appRsaSecret;
    options.sdkComponents = functions;

    [EAPMApm startWithOptions:options];
}

- (nullable NSString *)normalizedConfigValue:(nullable NSString *)value {
    NSString *trimmedValue = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedValue.length > 0 ? trimmedValue : nil;
}

- (BOOL)isConfiguredValue:(nullable NSString *)value {
    return [self normalizedConfigValue:value] != nil;
}

- (void)configureLaunchBlockingAlertOnHomeInterface {
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    if (![navigationController isKindOfClass:[UINavigationController class]]) {
        return;
    }

    EAPMDemoHomeViewController *homeViewController = (EAPMDemoHomeViewController *)navigationController.topViewController;
    if (![homeViewController isKindOfClass:[EAPMDemoHomeViewController class]]) {
        return;
    }

    homeViewController.launchBlockingAlertTitle = @"应用配置缺失";
    homeViewController.launchBlockingAlertMessage = @"当前缺少 appKey 等应用配置。\n\n请前往 EMAS 控制台获取应用配置，并修改 AppDelegate 中的 APM 配置后重新启动应用。";
    __weak typeof(self) weakSelf = self;
    homeViewController.launchBlockingAlertActionHandler = ^{
        [weakSelf terminateApplication];
    };
}

- (void)terminateApplication {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        exit(0);
    });
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
