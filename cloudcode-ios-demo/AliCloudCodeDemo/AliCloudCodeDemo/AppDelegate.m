//
//  AppDelegate.m
//  AliCloudCodeDemo
//
//  Created by yannan on 2021/2/26.
//

#import "AppDelegate.h"
#import <AlicloudCloudCode/AliCloudCodeAdSDK.h>


static NSString *const CHANNELID = @"TEST_TENANT";
static NSString *const MEDIAID = @"566389535148903424";


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [AliCloudCodeAdSDK setLogEnable:YES];
    [AliCloudCodeAdSDK setChannelID:CHANNELID mediaID:MEDIAID];
    [AliCloudCodeAdSDK sdkInit:^(BOOL isSuccess, NSError * _Nonnull error) {
        if (isSuccess) {
            //SDK 初始化成功
        } else {
            //SDK 初始化失败
            NSLog(@"失败原因：%@", error.description);
        }
    }];
    
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
