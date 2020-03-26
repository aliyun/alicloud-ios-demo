//
//  AppDelegate.m
//  devops-ios-demo
//
//  Created by 魏晓堃 on 2019/12/11.
//  Copyright © 2019 魏晓堃. All rights reserved.
//

#import "AppDelegate.h"
#import "EMASDevOpsInfo.h"

static NSString *const mAppKey = @"your app key";
static NSString *const mAppSecret = @"your app secret";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [EMASDevOpsInfo shareInstance].identifier = [NSString stringWithFormat:@"%@@iphoneos", mAppKey];
    
    
    return YES;
}




@end
