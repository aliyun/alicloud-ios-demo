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

static NSString *const testAppKey = @"******";
static NSString *const testAppSecret = @"******";

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
  // [CloudPushSDK handleLaunching:launchOptions];(Deprecated from v1.8.1)
  [CloudPushSDK sendNotificationAck:launchOptions];
  
  return YES;
}

- (void)initCloudPush {
  // 正式上线建议关闭
  [CloudPushSDK turnOnDebug];
  // SDK初始化
  [CloudPushSDK asyncInit:testAppKey appSecret:testAppSecret callback:^(CloudPushCallbackResult *res) {
    if (res.success) {
      NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
      
      /* RN弹窗展示 */
      [self.bridge.eventDispatcher sendAppEventWithName:@"DeviceIdReminder" body:@{
                                                                                  @"deviceId" : [CloudPushSDK getDeviceId]
                                                                                  }];
      
    } else {
      NSLog(@"Push SDK init failed, error: %@", res.error);
    }
  }];
}

#pragma mark APNs Register
/**
 *  向APNs注册，获取deviceToken用于推送
 *
 *  @param   application
 */
- (void)registerAPNS:(UIApplication *)application {
  float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
  if (systemVersionNum >= 10.0) {
    // iOS 10 notifications
    _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    // 创建category，并注册到通知中心
    [self createCustomNotificationCategory];
    _notificationCenter.delegate = self;
    // 请求推送权限
    [_notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
      if (granted) {
        // granted
        NSLog(@"User authored notification.");
        // 向APNs注册，获取deviceToken
        [application registerForRemoteNotifications];
      } else {
        // not granted
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
 *  主动获取设备通知是否授权(iOS 10+)
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

/*
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

/*
 *  APNs注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

/**
 *  创建并注册通知category(iOS 10+)
 */
- (void)createCustomNotificationCategory {
  // 自定义`action1`和`action2`
  UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"test1" options: UNNotificationActionOptionNone];
  UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"test2" options: UNNotificationActionOptionNone];
  // 创建id为`test_category`的category，并注册两个action到category
  // UNNotificationCategoryOptionCustomDismissAction表明可以触发通知的dismiss回调
  UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"test_category" actions:@[action1, action2] intentIdentifiers:@[] options:
                                      UNNotificationCategoryOptionCustomDismissAction];
  // 注册category到通知中心
  [_notificationCenter setNotificationCategories:[NSSet setWithObjects:category, nil]];
}

/**
 *  处理iOS 10通知(iOS 10+)
 */
- (void)handleiOS10Notification:(UNNotification *)notification {
  UNNotificationRequest *request = notification.request;
  UNNotificationContent *content = request.content;
  NSDictionary *userInfo = content.userInfo;
  // 通知时间
  NSDate *noticeDate = notification.date;
  // 标题
  NSString *title = content.title;
  // 副标题
  NSString *subtitle = content.subtitle;
  // 内容
  NSString *body = content.body;
  // 角标
  int badge = [content.badge intValue];
  // 取得通知自定义字段内容，例：获取key为"Extras"的内容
  NSString *extras = [userInfo valueForKey:@"Extras"];
  // 通知打开回执上报
  [CloudPushSDK sendNotificationAck:userInfo];
  NSLog(@"Notification, date: %@, title: %@, subtitle: %@, body: %@, badge: %d, extras: %@.", noticeDate, title, subtitle, body, badge, extras);
}

/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
  NSLog(@"Receive a notification in foregound.");
  // 处理iOS 10通知，并上报通知打开回执
  [self handleiOS10Notification:notification];
  // 通知不弹出
  completionHandler(UNNotificationPresentationOptionNone);
  
  // 通知弹出，且带有声音、内容和角标
  //completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
  NSString *userAction = response.actionIdentifier;
  // 点击通知打开
  if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
    NSLog(@"User opened the notification.");
    // 处理iOS 10通知，并上报通知打开回执
    [self handleiOS10Notification:response.notification];
  }
  // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
  if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
    NSLog(@"User dismissed the notification.");
  }
  NSString *customAction1 = @"action1";
  NSString *customAction2 = @"action2";
  // 点击用户自定义Action1
  if ([userAction isEqualToString:customAction1]) {
    NSLog(@"User custom action1.");
  }
  
  // 点击用户自定义Action2
  if ([userAction isEqualToString:customAction2]) {
    NSLog(@"User custom action2.");
  }
  completionHandler();
}

/**
 *  推送通道打开回调
 *
 *  @param   notification
 */
- (void)onChannelOpened:(NSNotification *)notification {
  NSLog(@"推送通道建立成功");
}

#pragma mark Receive Message
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
 *
 *  @param   notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
  NSLog(@"Receive one message!");
  
  CCPSysMessage *message = [notification object];
  NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
  NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
  NSLog(@"Receive message title: %@, content: %@.", title, body);
  
  /* RN弹窗展示 */
  [self.bridge.eventDispatcher sendAppEventWithName:@"MessageReminder" body:@{
                                                                      @"title" : title,
                                                                      @"body" : body
                                                                      }];
}

@end
