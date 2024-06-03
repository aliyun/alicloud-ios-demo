//
//  AlSelectionPanelViewController.swift
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/6/3.
//  Copyright © 2024 alibaba. All rights reserved.
//

import UIKit

class AlSelectionPanelViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func httpsScenario(_ sender: Any) {
        cleanTextView()

        AlHttpsScenario.httpDnsQueryWithURL(originalUrl: "https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt") { message in
            DispatchQueue.main.async {
                self.textView.text = message
            }
        }
    }
    
    @IBAction func httpsWithSNIScenario(_ sender: Any) {
        cleanTextView()
        
        AlHttpsWithSNIScenario.httpDnsQueryWithURL(originalUrl: "https://ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com/example-resources.txt") { message in
            DispatchQueue.main.async {
                self.textView.text = message
            }
        }
    }

    func cleanTextView() {
        textView.setContentOffset(.zero, animated: false)
        textView.text = ""
    }
}
