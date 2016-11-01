//
//  NotificationService.swift
//  mpush_service_extension
//
//  Created by junmo on 16/11/1.
//  Copyright © 2016年 junmo. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            
            // 修改通知标题，方便查看通知显示效果
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            // 获取通知中自定义KV字段，此处取key为`attachment`的value，为阿里云logo图片的Url地址
            // 控制台 or OpenAPI推送时需要设定iOSExtParameters，其中携带`attachment`KV
            let picUrlString = request.content.userInfo["attachment"]
            if (picUrlString != nil) {
                let picPath = NSHomeDirectory().appending("/Documents").appending("/notice_media.png")
                // 下载图片到本地
                let urlSession = URLSession.shared
                let downloadTask = urlSession.downloadTask(with: URL.init(string: picUrlString as! String)!, completionHandler: { (location, response, error) in
                    if (error != nil) {
                        bestAttemptContent.body = error.debugDescription
                        contentHandler(bestAttemptContent)
                    } else {
                        // 图片存储到指定picPath位置
                        let fm = FileManager.default
                        do {
                           try fm.moveItem(atPath: location!.path, toPath: picPath)
                        } catch let error as NSError {
                            bestAttemptContent.body = error.localizedDescription
                            contentHandler(bestAttemptContent)
                        }
                        // 创建通知附件
                        do {
                            let attachment: UNNotificationAttachment
                            try attachment = UNNotificationAttachment.init(identifier: "pic", url: URL.init(fileURLWithPath: picPath), options: nil)
                            bestAttemptContent.attachments = [attachment]
                        } catch let error as NSError {
                            bestAttemptContent.body = error.localizedDescription
                        }
                    }
                    contentHandler(bestAttemptContent)
                })
                downloadTask.resume()
            } else {
                // 若没有指定资源Url，从本地获取资源添加到通知中
                let picLocalPath = Bundle.main.path(forResource: "aliyun-logo-local", ofType: "png")
                if (picLocalPath != nil) {
                    // 创建通知附件
                    do {
                        let attachment: UNNotificationAttachment
                        try attachment = UNNotificationAttachment.init(identifier: "pic", url: URL.init(fileURLWithPath: picLocalPath!), options: nil)
                        bestAttemptContent.attachments = [attachment]
                    } catch let error as NSError {
                        bestAttemptContent.body = error.localizedDescription
                    }
                }
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
