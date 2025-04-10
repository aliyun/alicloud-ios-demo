//
//  ActivityInfo.swift
//  mpush_ios_demo
//
//  Created by Miracle on 2025/4/1.
//  Copyright © 2025 alibaba. All rights reserved.
//

import UIKit

struct ActivityInfo {
    /// 状态
    var state: String = "-"
    /// 数据模型
    var modelName: String = "-"
    /// 活动id
    var id: String = "-"
    /// 模型类型
    var modelType: String = "-"
    /// 过期时间
    var staleDate: Date?
    /// 静态参数
    var staticParams = [String:String]()
    /// 动态参数
    var dynamicParams = [String:String]()
}
