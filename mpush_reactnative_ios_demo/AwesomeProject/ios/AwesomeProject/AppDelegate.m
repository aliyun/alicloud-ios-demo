/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTEventDispatcher.h>

#import <CloudPushSDK/CloudPushSDK.h>

// iOS 10 notification
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate
{
  UNUserNotificationCenter *_notificationCenter;
}

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURL *jsCodeLocation;

  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"AwesomeProject"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  
  
  // APNs注册，获取deviceToken并上报
  [self registerAPNS:application];
  // 初始化SDK
  [self initCloudPush];
  // 监听推送通道打开动作
  [self listenerOnChannelOpened];
  // 监听推送消息到达
  [self registerMessageReceive];
  // 点击通知将App从关闭状态启动时，将通知打开回执上报
  [CloudPushSDK sendNotificationAck:launchOptions];
  
  return YES;
  
}

- (void)initCloudPush {
  
  // 正式上线建议关闭
  [CloudPushSDK turnOnDebug];

  // 请从控制台下载 AliyunEmasServices-Info.plist 配置文件，并正确拖入工程 SDK初始化，无需输入配置信息
  [CloudPushSDK autoInit:^(CloudPushCallbackResult *res) {
      if (res.success) {
          NSLog(@"\n ======== Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
        /** RN弹窗展示 */
        [self.bridge.eventDispatcher sendAppEventWithName:@"DeviceIdReminder" body:@{
                                                                                    @"deviceId" : [CloudPushSDK getDeviceId] }];
      } else {
          NSLog(@"\n ======== Push SDK init failed, error: %@", res.error);
      }
  }];
  
}

 
/**
 *  向 APNs 注册，获取 deviceToken 用于推送
 *  @param   application
 */
- (void)registerAPNS:(UIApplication *)application {
  float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
  if (systemVersionNum >= 10.0) {
 
    _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
 
    [self createCustomNotificationCategory];
    _notificationCenter.delegate = self;
    // 请求推送权限
    [_notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
      if (granted) {
    
        NSLog(@"User authored notification.");
        // 向 APNs 注册，获取deviceToken
        [application registerForRemoteNotifications];
      } else {
    
        NSLog(@"User denied notification.");
      }
    }];
  } else if (systemVersionNum >= 8.0) {
    // iOS 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    [application registerUserNotificationSettings:
     [UIUserNotificationSettings settingsForTypes:
      (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                       categories:nil]];
    [application registerForRemoteNotifications];
#pragma clang diagnostic pop
  } else {
    // iOS < 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#pragma clang diagnostic pop
  }
}

/**
 *  主动获取设备通知是否授权 (iOS 10+)
 */
- (void)getNotificationSettingStatus {
  [_notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
    if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
      NSLog(@"User authed.");
    } else {
      NSLog(@"User denied.");
    }
  }];
}

/**
 *  APNs注册成功回调，将返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSLog(@"Upload deviceToken to CloudPush server.");
  [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
    if (res.success) {
      NSLog(@"Register deviceToken success, deviceToken: %@", [CloudPushSDK getApnsDeviceToken]);
    } else {
      NSLog(@"Register deviceToken failed, error: %@", res.error);
    }
  }];
}

/**
 *  APNs注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

/**
 *  创建并注册通知category(iOS 10+)
 */
- (void)createCustomNotificationCategory {

  UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"test1" options: UNNotificationActionOptionNone];
  UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"test2" options: UNNotificationActionOptionNone];
  UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"test_category" actions:@[action1, action2] intentIdentifiers:@[] options:
                                      UNNotificationCategoryOptionCustomDismissAction];
  // 注册category到通知中心
  [_notificationCenter setNotificationCategories:[NSSet setWithObjects:category, nil]];
}

/**
 *  处理 iOS 10+ 通知
 */
- (void)handleiOS10Notification:(UNNotification *)notification {
  UNNotificationRequest *request = notification.request;
  UNNotificationContent *content = request.content;
  NSDictionary *userInfo = content.userInfo;

  NSDate *noticeDate = notification.date;
  NSString *title = content.title;
  NSString *subtitle = content.subtitle;
  NSString *body = content.body;
  int badge = [content.badge intValue];
  // 取得通知自定义字段内容，例：获取key为"Extras"的内容
  NSString *extras = [userInfo valueForKey:@"Extras"];
  // 通知打开回执上报
  [CloudPushSDK sendNotificationAck:userInfo];
  NSLog(@"Notification, date: %@, title: %@, subtitle: %@, body: %@, badge: %d, extras: %@.", noticeDate, title, subtitle, body, badge, extras);
}

/**
 *  iOS 10 + 实现两个代理方法之一 。
 *  App 处于 前台 时收到 通知 (iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
  NSLog(@"Receive a notification in foregound.");
  // 处理iOS 10 通知，并上报通知打开回执
  [self handleiOS10Notification:notification];
  // 通知弹出，且带有声音、内容和角标
  completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

/**
 *  iOS 10 + 实现两个代理方法之一。
 *  APP 处于 后台 点击 通知栏 通知
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
   
  NSString *userAction = response.actionIdentifier;
  
  if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
    NSLog(@"User opened the notification.");
    // 处理 iOS 10 通知 并上报通知打开回执
    [self handleiOS10Notification:response.notification];
  }
  
  if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
    NSLog(@"User dismissed the notification.");
  }
  NSString *customAction1 = @"action1";
  NSString *customAction2 = @"action2";
  
  if ([userAction isEqualToString:customAction1]) {
    NSLog(@"User custom action1.");
  }
  if ([userAction isEqualToString:customAction2]) {
    NSLog(@"User custom action2.");
  }
  completionHandler();
  
}

/**
 *  推送通道打开回调
 *  @param   notification
 */
- (void)onChannelOpened:(NSNotification *)notification {
  NSLog(@"推送通道建立成功");
}


/**
 *  @brief  注册推送消息到来监听
 */
- (void)registerMessageReceive {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onMessageReceived:)
                                               name:@"CCPDidReceiveMessageNotification"
                                             object:nil];
}

/**
 *  注册推送通道打开监听
 */
- (void)listenerOnChannelOpened {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onChannelOpened:)
                                               name:@"CCPDidChannelConnectedSuccess"
                                             object:nil];
}

/**
 *  处理到来推送消息
 *  @param   notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
  NSLog(@"Receive one message!");
  
  CCPSysMessage *message = [notification object];
  NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
  NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
  NSLog(@"Receive message title: %@, content: %@.", title, body);
  
  /** RN弹窗展示 */
  [self.bridge.eventDispatcher sendAppEventWithName:@"MessageReminder" body:@{
                                                                      @"title" : title,
                                                                      @"body" : body
                                                                      }];
}

@end
