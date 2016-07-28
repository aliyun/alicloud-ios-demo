//
//  LZLPushMessage.swift
//  mpush_swift_demo
//
//  Created by fuyuan.lfy on 16/7/25.
//  Copyright © 2016年 alibaba.qa. All rights reserved.
//

import UIKit

class LZLPushMessage: NSObject {
    var id : Int = 0
    var messageContent : String = ""
    var isRead : Bool
    
    init (id : Int, messageContent: String, isRead : Bool) {
        self.id = id
        self.messageContent = messageContent
        self.isRead = isRead
    }
    
    override init() {
        self.id = 0
        self.messageContent = ""
        self.isRead = false
    }
}
