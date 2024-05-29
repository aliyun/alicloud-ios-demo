//
//  AlChooseTypeVC.swift
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/5/27.
//  Copyright © 2024 alibaba. All rights reserved.
//

import UIKit

class AlChooseTypeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func beginHttpsScene(_ sender: Any) {
        cleanTextView()

        var responseIp: String = ""
        let originalUrl = "https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt"

        AlHttpsScene().beginQuery(originalUrl: originalUrl) {[weak self] ip, text in
            responseIp = ip
            if !ip.isEmpty {
                DispatchQueue.main.async {
                    self?.textView.text = text
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: DispatchWorkItem(block: {
            if responseIp.isEmpty {
                AlHttpsScene().beginQuery(originalUrl: originalUrl) {[weak self] ip, text in
                        self?.textView.text = text
                }
            }
        }))
    }

    @IBAction func beginHttpsWithSNIScene(_ sender: Any) {
        cleanTextView()

        var responseIp: String = ""
        let originalUrl = "https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt"

        ALHttpsWithSNIScene.beginQuery(originalUrl: originalUrl) {[weak self] ip, text in
            responseIp = ip
            if !ip.isEmpty {
                DispatchQueue.main.async {
                    self?.textView.text = text
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: DispatchWorkItem(block: {
            if responseIp.isEmpty {
                ALHttpsWithSNIScene.beginQuery(originalUrl: originalUrl) {[weak self] ip, text in
                        self?.textView.text = text
                }
            }
        }))
    }

    func cleanTextView() {
        textView.setContentOffset(.zero, animated: true)
        textView.text = ""
    }
}
