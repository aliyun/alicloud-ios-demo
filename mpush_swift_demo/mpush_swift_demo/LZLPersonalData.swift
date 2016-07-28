//
//  LZLPersonData.swift
//  mpush_swift_demo
//
//  Created by fuyuan.lfy on 16/7/25.
//  Copyright © 2016年 alibaba.qa. All rights reserved.
//

import UIKit

class LZLPersonalData: NSObject {
    var id : Int
    var itemName : String
    var itemValue : String
    
    init(id : Int, itemName : String, itemValue : String) {
        self.id = id
        self.itemName = itemName
        self.itemValue = itemValue
    }
    
    override init() {
        self.id = 0
        self.itemName = ""
        self.itemValue = ""
    }
}
