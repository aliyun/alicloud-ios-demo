//
//  AppDelegate.m
//  man_ios_demo
//
//  Created by nanpo.yhl on 15/10/10.
//  Copyright (c) 2015年 com.aliyun.mobile. All rights reserved.
//

#import "AppDelegate.h"

#import <AlicloudMobileAnalitics/ALBBMAN.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *testAppKey = @"********";
    NSString *testAppSecret = @"********";
    
    // 获取MAN服务
    ALBBMANAnalytics *man = [ALBBMANAnalytics getInstance];
    
    // 打开调试日志，线上建议关闭
    [man turnOnDebug];
    
    // 初始化MAN，手动输入appKey/appSecret配置信息
    //[man initWithAppKey:testAppKey secretKey:testAppSecret];
    
    // 初始化MAN，无需输入配置信息
    // 请从控制台下载AliyunEmasServices-Info.plist配置文件，并正确拖入工程
    [man autoInit];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
