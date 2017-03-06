//
//  MsgToolBox.swift
//  mpush_ios_swift_demo
//
//  Created by mac on 2017/3/6.
//  Copyright © 2017年 Rock. All rights reserved.
//

import UIKit

class MsgToolBox: NSObject {
    
    static public func showAlert(title: String, content: String) -> () {
        //保证在主线程上执行
        if Thread.isMainThread == true {
            let alertView = UIAlertView.init(title: title, message: content, delegate: self, cancelButtonTitle: "已阅")
            alertView.show()
        } else {
            DispatchQueue.main.async {
                let alertView = UIAlertView.init(title: title, message: content, delegate: self, cancelButtonTitle: "已阅")
                alertView.show()
            }
        }
    }


}
