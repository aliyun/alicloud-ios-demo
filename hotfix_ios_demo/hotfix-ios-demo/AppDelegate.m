//
//  AppDelegate.m
//  hotfix-ios-demo
//
//  Created by junmo on 2017/10/19.
//  Copyright © 2017年 junmo. All rights reserved.
//

#import <AlicloudHotFix/AlicloudHotFix.h>
#import "AppDelegate.h"

#warning 设置AppId / AppSecret / RsaPrivateKey
static NSString *const testAppId = @"<#Your AppId#>";
static NSString *const testAppSecret = @"<#Your AppSecret#>";
static NSString *const testAppRsaPrivateKey = @"<#Your RSA Private Key#>";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self hotfixSdkInit];
    
    return YES;
}

- (void)hotfixSdkInit {
    AlicloudHotFixService *hotfixService = [AlicloudHotFixService sharedInstance];
#warning 打开Log
    [hotfixService setLogEnabled:YES];
#warning 手动设置App版本号
    [hotfixService setAppVersion:@"1.0"];
    [hotfixService initWithAppId:testAppId appSecret:testAppSecret rsaPrivateKey:testAppRsaPrivateKey callback:^(BOOL res, id data, NSError *error) {
        if (res) {
            NSLog(@"HotFix SDK init success.");
        } else {
            NSLog(@"HotFix SDK init failed, error: %@", error);
        }
    }];
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
