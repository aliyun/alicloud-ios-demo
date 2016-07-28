//
//  MsgToolBox.swift
//  mpush_swift_demo
//
//  Created by fuyuan.lfy on 16/7/26.
//  Copyright © 2016年 alibaba.qa. All rights reserved.
//

import UIKit

class MsgToolBox: NSObject {
    static func showAlert(title: String, content: String) {
        // 保证在主线程上执行
        if NSThread.isMainThread() {
            let alertView = UIAlertView.init(title: title, message: content, delegate: nil, cancelButtonTitle: "已阅")
            alertView.show()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                let alertView = UIAlertView.init(title: title, message: content, delegate: nil, cancelButtonTitle: "已阅")
                alertView.show()
            })
        }
    }
}
