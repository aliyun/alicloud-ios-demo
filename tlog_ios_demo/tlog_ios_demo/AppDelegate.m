//
//  AppDelegate.m
//  tlog_ios_demo
//
//  Created by sky on 2019/10/11.
//  Copyright © 2019 aliyun. All rights reserved.
//

#import "AppDelegate.h"
#import <AlicloudTLog/AlicloudTlogProvider.h>
#import <AliHACore/AlicloudHAProvider.h>
#import <TRemoteDebugger/TRDManagerService.h>
#import <UTDID/UTDID.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *appVersion = @"x.x"; //app版本，会上报
    NSString *channel = @"xx";     //渠道标记，自定义，会上报
    NSString *nick = @"xx";        //nick 昵称，自定义，会上报
    //初始化方式1
    [[AlicloudTlogProvider alloc] autoInitWithAppVersion:appVersion channel:channel nick:nick];
    //初始化方式2
//    [[AlicloudTlogProvider alloc] initWithAppKey:@"333740861" secret:@"b4eecb377a2b42a19dd60bbe5abb2766" tlogRsaSecret:@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDHimlzBzzTPZ9eiKjan1YuXyhMET/lXm0qbLUE+UBr5y7vwGA/nCr7lp2P0uJDuEMRSGpZ2Aan4+U8b+KDse6QBCua7ILDYzKIV52fVdHh+eOsVussP4EZknqG3okt7lCdYbQFPtgp8rR+FNECGtw/yM+akU5F+AStIXXNGPW73wIDAQAB" appVersion:appVersion channel:channel nick:nick];
    [AlicloudHAProvider start];
    NSLog(@"\n\nemas-test\n\nutdid:\n%@\n\n",[UTDevice utdid]);

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
