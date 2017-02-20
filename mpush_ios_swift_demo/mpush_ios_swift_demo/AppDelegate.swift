//
//  AppDelegate.swift
//  mpush_ios_swift_demo
//
//  Created by junmo on 16/10/23.
//  Copyright © 2016年 junmo. All rights reserved.
//

import UIKit
// iOS 10+ notificaiton
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    let testAppKey = "23638938"
    let testAppSecret = "51a30812715049d2994a619e3b758611"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // APNs注册，获取deviceToken并上报
        registerAPNs(application)
        // 初始化阿里云推送SDK
        initCloudPushSDK()
        // 监听推送通道打开动作
        listenOnChannelOpened()
        // 监听推送消息到达
        registerMessageReceive()
        // 点击通知将App从关闭状态启动时，将通知打开回执上报
        //CloudPushSDK.handleLaunching(launchOptions)(Deprecated from v1.8.1)
        CloudPushSDK.sendNotificationAck(launchOptions)
        return true
    }
    
    // 向APNs注册，获取deviceToken用于推送
    func registerAPNs(_ application: UIApplication) {
        if #available(iOS 10, *) {
            // iOS 10+
            let center = UNUserNotificationCenter.current()
            // 创建category，并注册到通知中心
            createCustomNotificationCategory()
            center.delegate = self
            // 请求推送权限
            center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
                if (granted) {
                    // User authored notification
                    print("User authored notification.")
                    // 向APNs注册，获取deviceToken
                    application.registerForRemoteNotifications()
                } else {
                    // User denied notification
                    print("User denied notification.")
                }
            })
        } else if #available(iOS 8, *) {
            // iOS 8+
            application.registerUserNotificationSettings(UIUserNotificationSettings.init(types: [.alert, .badge, .sound], categories: nil))
            application.registerForRemoteNotifications()
        } else {
            // < iOS 8
            application.registerForRemoteNotifications(matching: [.alert,.badge,.sound])
        }
    }

    // 创建自定义category，并注册到通知中心
    @available(iOS 10, *)
    func createCustomNotificationCategory() {
        let action1 = UNNotificationAction.init(identifier: "action1", title: "test1", options: [])
        let action2 = UNNotificationAction.init(identifier: "action2", title: "test2", options: [])
        let category = UNNotificationCategory.init(identifier: "test_category", actions: [action1, action2], intentIdentifiers: [], options: UNNotificationCategoryOptions.customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    // 初始化推送SDK
    func initCloudPushSDK() {
        // 打开Log，线上建议关闭
        CloudPushSDK.turnOnDebug()
        CloudPushSDK.asyncInit(testAppKey, appSecret: testAppSecret) { (res) in
            if (res!.success) {
                print("Push SDK init success, deviceId: \(CloudPushSDK.getDeviceId()!)")
            } else {
                print("Push SDK init failed, error: \(res!.error!).")
            }
        }
    }
    
    // 监听推送通道是否打开
    func listenOnChannelOpened() {
        let notificationName = Notification.Name("CCPDidChannelConnectedSuccess")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(channelOpenedFunc(notification:)),
                                               name: notificationName,
                                               object: nil)
    }
    
    func channelOpenedFunc(notification : Notification) {
        print("Push SDK channel opened.")
        let msgToolBox: MsgToolBox = MsgToolBox.init()
        msgToolBox.showAlert(title: "温馨提示", content: "消息通道建立成功")
  
    }

    
    // 注册消息到来监听
    func registerMessageReceive() {
        let notificationName = Notification.Name("CCPDidReceiveMessageNotification")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onMessageReceivedFunc(notification:)),
                                               name: notificationName,
                                               object: nil)
    }
    
    // 处理推送消息
    func onMessageReceivedFunc(notification : Notification) {
        print("Receive one message.")
        let pushMessage: CCPSysMessage = notification.object as! CCPSysMessage
        let title = String.init(data: pushMessage.title, encoding: String.Encoding.utf8)
        let body = String.init(data: pushMessage.body, encoding: String.Encoding.utf8)
        print("Message title: \(title!), body: \(body!).")
    
        //==========================
        //FIXME:此处做了改动
        let tempVO: LZLPushMessage = LZLPushMessage.init()
        tempVO.messageContent = "title:\(title) , content: \(body)"
        tempVO.isRead = false
        
        let isMain = Thread.isMainThread
   
        //FIXME: 此处做了改动 需要判断
        if  isMain == false  {

            DispatchQueue.main.async {
                if tempVO.messageContent != nil {
                    self.insertPushMessage(model: tempVO)
                }
            }
            
        }else {
            if tempVO.messageContent != nil {
                self.insertPushMessage(model: tempVO)
                
            }
        }
    
    }
    
    func insertPushMessage(model: LZLPushMessage ) -> () {
        let dao : PushMessageDAO =  PushMessageDAO.init()
        dao.insert(model)
        
    }
    
      //==========================
    
    
    
    // App处于启动状态时，通知打开回调（< iOS 10）
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Receive one notification.")
        let aps = userInfo["aps"] as! [AnyHashable : Any]
        let alert = aps["alert"] ?? "none"
        let badge = aps["badge"] ?? 0
        let sound = aps["sound"] ?? "none"
        let extras = userInfo["Extras"]
        print("Notification, alert: \(alert), badge: \(badge), sound: \(sound), extras: \(extras).")
    }
    
    // 处理iOS 10通知(iOS 10+)
    @available(iOS 10.0, *)
    func handleiOS10Notification(_ notification: UNNotification) {
        let content: UNNotificationContent = notification.request.content
        let userInfo = content.userInfo
        // 通知时间
        let noticeDate = notification.date
        // 标题
        let title = content.title
        // 副标题
        let subtitle = content.subtitle
        // 内容
        let body = content.body
        // 角标
        let badge = content.badge ?? 0
        // 取得通知自定义字段内容，例：获取key为"Extras"的内容
        let extras = userInfo["Extras"]
        // 通知打开回执上报
        CloudPushSDK.sendNotificationAck(userInfo)
        print("Notification, date: \(noticeDate), title: \(title), subtitle: \(subtitle), body: \(body), badge: \(badge), extras: \(extras).")
    }
    
    // App处于前台时收到通知(iOS 10+)
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Receive a notification in foreground.")
        handleiOS10Notification(notification)
        // 通知不弹出
        completionHandler([])
        // 通知弹出，且带有声音、内容和角标
        //completionHandler([.alert, .badge, .sound])
    }
    
    // 触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
    @available(iOS 10, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userAction = response.actionIdentifier
        if userAction == UNNotificationDefaultActionIdentifier {
            print("User opened the notification.")
            // 处理iOS 10通知，并上报通知打开回执
            handleiOS10Notification(response.notification)
        }
        
        if userAction == UNNotificationDismissActionIdentifier {
            print("User dismissed the notification.")
        }
        
        let customAction1 = "action1"
        let customAction2 = "action2"
        if userAction == customAction1 {
            print("User touch custom action1.")
        }
        
        if userAction == customAction2 {
            print("User touch custom action2.")
        }
        
        completionHandler()
    }
    
    // APNs注册成功
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Get deviceToken from APNs success.")
        CloudPushSDK.registerDevice(deviceToken) { (res) in
            if (res!.success) {
                print("Upload deviceToken to Push Server, deviceToken: \(CloudPushSDK.getApnsDeviceToken()!)")
            } else {
                print("Upload deviceToken to Push Server failed, error: \(res?.error)")
            }
        }
    }
    
    // APNs注册失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Get deviceToken from APNs failed, error: \(error).")
    }
    
    // 禁止横屏
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait;
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

