//
//  AppDelegate.swift
//  mpush_swift_demo
//
//  Created by fuyuan.lfy on 16/7/19.
//  Copyright © 2016年 alibaba.qa. All rights reserved.
//

import UIKit
import MPushSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 向苹果注册推送，获取deviceToken并上报
        self.registerAPNS(application)
        // 初始化SDK
        self.initCloudPush()
        // 监听推送通道打开动作
        self.listenerOnChannelOpened()
        // 监听推送消息到来
        self.registerMessageReceive()
        // 点击通知将App从关闭状态启动时，将通知打开回执上报
        CloudPushSDK.handleLaunching(launchOptions)
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /*
     *  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
     */
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("Upload deviceToken to CloudPush server.")
        CloudPushSDK.registerDevice(deviceToken, withCallback: {(res) in
            if res.success {
                print("Register deviceToken success.")
            } else {
                print("Register deviceToken failed, error: \(res.error)")
            }
        })
    }
    
    /*
     *  苹果推送注册失败回调
     */
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("didFailToRegisterForRemoteNotificationsWithError \(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("Receive one notification.")
        // 取得APNS通知内容
        let aps = userInfo["aps"] as! NSDictionary
        // 内容
        let content = aps["alert"]
        // badge数量
        let badge = aps["badge"]?.integerValue
        // 播放声音
        let sound = aps["sound"]
        // 取得Extras字段内容
        let Extras = userInfo["Extras"] //服务端中Extras字段，key是自己定义的
        print("content = [\(content)], badge = [\(badge)], sound = [\(sound)], Extras = [\(Extras)]")
        // iOS badge 清0
        application.applicationIconBadgeNumber = 0;
        // 通知打开回执上报
        CloudPushSDK.handleReceiveRemoteNotification(userInfo)
    }
    
    /**
     *	注册苹果推送，获取deviceToken用于推送
     *
     *	@param 	application
     */
    func registerAPNS(application: UIApplication) {
        if #available(iOS 8.0, *) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound], categories: nil))
            application.registerForRemoteNotifications()
        } else {
            // Fallback on earlier versions
            UIApplication.sharedApplication().registerForRemoteNotificationTypes([.Alert, .Badge, .Sound])
        }
    }
    
    func initCloudPush() {
        // 正式上线建议关闭
        CloudPushSDK.turnOnDebug();
        // SDK初始化
        CloudPushSDK.asyncInit("23267207", appSecret: "379089f0019f8faba0c61fcdf00f678f", callback: {(res) in
            if res.success {
                print("Push SDK init success, deviceId: \(CloudPushSDK.getDeviceId()).")
                }
            }
            
        )
    }
    
    /**
     *	注册推送通道打开监听
     */
    func listenerOnChannelOpened() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onChannelOpened(_:)), name: "CCPDidChannelConnectedSuccess", object: nil)
    }
    
    /**
     *	推送通道打开回调
     *
     *	@param 	notification
     */
    func onChannelOpened(notification: NSNotificationCenter) {
        MsgToolBox.showAlert("温馨提示", content: "消息通道建立成功")
    }
    
    /**
     *	@brief	注册推送消息到来监听
     */
    func registerMessageReceive() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onMessageReceived(_:)), name: "CCPDidReceiveMessageNotification", object: nil)
    }
    
    /**
     *	处理到来推送消息
     *
     *	@param 	notification
     */
    func onMessageReceived(notification: NSNotification) {
        print("Receive one message!")
        
        let message = notification.object as! CCPSysMessage
        let title = String.init(data: message.title, encoding: NSUTF8StringEncoding)
        let body = String.init(data: message.body, encoding: NSUTF8StringEncoding)
        print("Receive message title: \(title), content: \(body).")
        
        let tempVO = LZLPushMessage()
        tempVO.messageContent = "title: \(title), content: \(body)"
        tempVO.isRead = false
        
        if !NSThread.isMainThread() {
            dispatch_async(dispatch_get_main_queue(), {
                    self.insertPushMessage(tempVO)
                })
        } else {
            self.insertPushMessage(tempVO)
        }
    }
    
    func insertPushMessage(model: LZLPushMessage) {
        
    }
    
    // 禁止横屏
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}

