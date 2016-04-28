//
//  AppDelegate.m
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/3/30.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "AppDelegate.h"
#import <ALBBSDK/ALBBSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

// ====================================== SDK Method. ==================================
#pragma mark 初始化服务
- (void)init_tae{
    
    //sdk初始化
    [[ALBBSDK sharedInstance] setALBBSDKEnvironment:ALBBSDKEnvironmentRelease];
    [[ALBBSDK sharedInstance] asyncInit:@"********" appSecret:@"********" :^{
        NSLog(@"init one sdk success %@", [CloudPushSDK getDeviceId]);
    }failedCallback:^(NSError *error){
        NSLog(@"error is %@", error);
    }];
}

- (void) listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChannelOpened:) name:@"CCPDidChannelConnectedSuccess" object:nil]; // 注册
}

#pragma mark 注册苹果的推送
-(void) registerAPNS :(UIApplication *)application :(NSDictionary *)launchOptions{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    [CloudPushSDK handleLaunching:launchOptions]; // 作为 apns 消息统计
}
#pragma mark 注册接收CloudChannel推送下来的消息
- (void) registerMsgReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageReceived:) name:@"CCPDidReceiveMessageNotification" object:nil]; // 注册
}
// 推送下来的消息抵达的处理示例
- (void)onMessageReceived:(NSNotification *)notification {
    NSData *data = [notification object];
    NSString *message = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    LZLPushMessage *tempVO = [[LZLPushMessage alloc] init];
    tempVO.messageContent = message;
    tempVO.isRead = 0;
    
    // 报警提示
    if(![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(tempVO.messageContent != nil) {
                [self insertPushMessage:tempVO];
            }
        });
    } else {
        if(tempVO.messageContent != nil) {
            [self insertPushMessage:tempVO];
        }
    }
}

- (void) insertPushMessage:(LZLPushMessage *)model {
    PushMessageDAO *dao = [[PushMessageDAO alloc] init];
    [dao insert:model];
}

#pragma marker 注册deviceToken
// 苹果推送服务回调，注册 deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [CloudPushSDK registerDevice:deviceToken];
}

// 通知统计回调
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    /// app open
    
    NSLog(@"收到通知一条~");
    // 打印自定义参数
    NSLog(@"自定义参数为 ： %@",userInfo);
    
    [CloudPushSDK handleReceiveRemoteNotification:userInfo];
}

//--------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//--------------------------------------------------------------------------------
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

// ====================================== SDK Method. =====================================


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"完成APP初始化");
    // 打印自定义参数
    NSLog(@"自定义参数为 ： %@",launchOptions);
    
    [self registerAPNS:application :launchOptions];
    [self init_tae];
    
    // 同时监听网络连接
    [self listenerOnChannelOpened];
    [self registerMsgReceive];
   
    return YES;
}

#pragma mark 推送下来的消息抵达的处理示例
- (void)onChannelOpened:(NSNotification *)notification {
    [MsgToolBox showAlert:@"温馨提示" content:@"消息通道建立成功"];
}

#pragma mark 禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"UserExperienceDemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"UserExperienceDemo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
