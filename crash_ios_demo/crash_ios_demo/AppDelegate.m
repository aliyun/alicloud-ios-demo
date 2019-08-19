//
//  AppDelegate.m
//  crash_ios_demo
//
//  Created by sky on 2019/8/7.
//  Copyright © 2019 sky. All rights reserved.
//

#import "AppDelegate.h"
#import <AliHAAdapter4Cloud/AliHAAdapter.h>
#import <TBCrashReporter/TBCrashReporter.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *appKey = @"xxxxxxx"; //appId
    NSString *secret = @"xxxxxxx"; //appSecret
    NSString *channel = @"xx";     //渠道标记，自定义，比如不同的应用商店等
    NSString *appVersion = @"x.x"; //app版本
    NSString *nick = @"xx";        //选填。自定义，会上报。可用于查找崩溃数据
    
    id<AliHAPluginProtocol> crashPlugin = [TBCrashReporter sharedReporter];
    NSArray<id<AliHAPluginProtocol>> *plugins = @[crashPlugin];
    [AliHAAdapter initWithAppKey:appKey secret:secret appVersion:appVersion channel:channel plugins:plugins nick:nick];
    
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
