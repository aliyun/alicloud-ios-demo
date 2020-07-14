//
//  AppDelegate.m
//  crash_ios_demo
//
//  Created by sky on 2019/8/7.
//  Copyright © 2019 sky. All rights reserved.
//

#import "AppDelegate.h"
#import <AlicloudCrash/AlicloudCrashProvider.h>
#import <AlicloudHAUtil/AlicloudHAProvider.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 接入方式一:使用配置文件
    // 请去控制台下载AliyunEmasServices-Info.plist，并替换本地文件
    NSString *appVersion = @"x.x"; //app版本，会上报
    NSString *channel = @"xx";     //渠道标记，自定义，会上报
    NSString *nick = @"xx";        //nick 昵称，自定义，会上报
    [[AlicloudCrashProvider alloc] autoInitWithAppVersion:appVersion channel:channel nick:nick];
    [AlicloudHAProvider start];
    
//    // 接入方式二:不使用配置文件
//    NSString *appKey = @"xxxxxxx"; //appKey
//    NSString *secret = @"xxxxxxx"; //secret
//    NSString *appVersion = @"x.x"; //app版本，会上报
//    NSString *channel = @"xx";     //渠道标记，自定义，会上报
//    NSString *nick = @"xx";        //nick 昵称，自定义，会上报
//
//    [[AlicloudCrashProvider alloc] initWithAppKey:appKey secret:secret appVersion:appVersion channel:channel nick:nick];
//    [AlicloudHAProvider start];
    
    return YES;
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
