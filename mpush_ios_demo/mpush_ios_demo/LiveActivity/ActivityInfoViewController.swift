//
//  ActivityInfoViewController.swift
//  mpush_ios_demo
//
//  Created by Miracle on 2025/4/1.
//  Copyright © 2025 alibaba. All rights reserved.
//

import UIKit

class ActivityInfoViewController: UIViewController {

    @IBOutlet weak var stateLabel: UILabel!

    @IBOutlet weak var modelNameLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!

    @IBOutlet weak var modelTypeLabel: UILabel!

    @IBOutlet weak var staleDateLabel: UILabel!

    @IBOutlet weak var staticParamsLabel: UILabel!
    
    @IBOutlet weak var dynamicParamsLabel: UILabel!

    var activityInfo = ActivityInfo()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.stateLabel.text = activityInfo.state
        self.modelNameLabel.text = activityInfo.modelName
        self.idLabel.text = activityInfo.id
        self.modelTypeLabel.text = activityInfo.modelType

        // 过期时间
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        // 处理可选类型
        if let date = activityInfo.staleDate {
            let staleDate = dateFormatter.string(from: date)
            self.stateLabel.text = staleDate
        }

        // 静态参数
        var staticString = ""
        let staticFormatted = activityInfo.staticParams.map { key, value in
            return "\(key): \(value)"
        }
        staticString += staticFormatted.joined(separator: "\n")
        self.staticParamsLabel.text = staticString

        // 动态参数
        var dynamicString = ""
        let dynamicFormatted = activityInfo.dynamicParams.map { key, value in
            return "\(key): \(value)"
        }
        dynamicString += dynamicFormatted.joined(separator: "\n")
        self.dynamicParamsLabel.text = dynamicString
    }

    // MARK: - Action
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }
}
