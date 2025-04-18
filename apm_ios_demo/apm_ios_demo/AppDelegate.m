//
//  AppDelegate.m
//  apm_ios_demo
//
//  Created by sky on 2019/10/11.
//  Copyright © 2019 aliyun. All rights reserved.
//

#import "AppDelegate.h"

#import <AlicloudApmCore/AlicloudApmCore.h>
#import <AlicloudApmCrashAnalysis/AlicloudApmCrashAnalysis.h>
#import <AlicloudApmPerformance/AlicloudApmPerformance.h>
#import <AlicloudApmRemoteLog/AlicloudApmRemoteLog.h>
#import "CommonTools.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initSDK];

    return YES;
}

- (void)initSDK {
    NSString *appKey = @"请替换您的appKey";
    NSString *appSecret = @"请替换您的appSecret";
    NSString *appRsaSecret = @"请替换您的appRsaSecret";
    
    // 崩溃分析：EAPMCrashAnalysis 性能分析：EAPMPerformance  远程日志：EAPMRemoteLog
    NSArray *functions = @[[EAPMCrashAnalysis class], [EAPMPerformance class], [EAPMRemoteLog class]];

    // 仅用于demo页面配置AppKey场景，非应用接入合理使用场景
    [CommonTools setUpConfigWithAppKey:&appKey appSecret:&appSecret appRsaSecret:&appRsaSecret functions:&functions];

    if (!appKey || !appSecret || !appRsaSecret || !functions) {
        NSLog(@"****初始化失败，请检查所有必需的配置参数****");
        return;
    }

    [[EAPMConfiguration sharedInstance] setLoggerLevel:EAPMLoggerLevelDebug];

    EAPMOptions *options = [[EAPMOptions alloc] initWithAppKey:appKey
                                                     appSecret:appSecret];

    options.userId = @"test";
    options.userNick = @"apmAllTest";
    options.channel = @"dev";
    options.appRsaSecret = appRsaSecret;
    options.sdkComponents = functions;

    [EAPMApm startWithOptions:options];
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
