//
//  AppDelegate.m
//  apm_ios_demo
//
//  Created by sky on 2019/10/11.
//  Copyright © 2019 aliyun. All rights reserved.
//

#import "AppDelegate.h"

#import <AlicloudApmCore/AlicloudApmCore.h>
#import "CommonTools.h"
#import "Macros.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initSDK];

    return YES;
}

- (void)initSDK {
    NSString *appKey = (NSString *)[CommonTools userDefaultGet:kAppKey];
    NSString *appSecret = (NSString *)[CommonTools userDefaultGet:kAppSecret];
    NSString *appRsaSecret = (NSString *)[CommonTools userDefaultGet:kAppRsaSecret];
    NSArray *funtions = (NSArray *)[CommonTools userDefaultGet:kFunctions];

    if (!appKey || !appSecret || !appRsaSecret || !funtions) {
        return;
    }

    [[EAPMConfiguration sharedInstance] setLoggerLevel:EAPMLoggerLevelDebug];

    EAPMOptions *options = [[EAPMOptions alloc] initWithAppKey:appKey
                                                     appSecret:appSecret];
    NSMutableArray *functionsClass = [NSMutableArray array];
    for (NSString *function in funtions) {
        [functionsClass addObject:NSClassFromString(function)];
    }

    options.userId = @"test";
    options.userNick = @"apmAllTest";
    options.channel = @"dev";
    options.appRsaSecret = appRsaSecret;
    options.sdkComponents = functionsClass;

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
