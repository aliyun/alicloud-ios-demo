//
//  MPushInfoViewController.swift
//  mpush_ios_swift_demo
//
//  Created by junmo on 16/10/24.
//  Copyright © 2016年 junmo. All rights reserved.
//

import UIKit

class MPushInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mpushInfoTableView: UITableView!
    
    var userInfoKeys: [String] = [String]()
    var userInfoValues: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //mpushInfoTableView.delegate = self
        //mpushInfoTableView.dataSource = self
        //initUserInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUserInfo() {
        print("Init user info.")
        userInfoKeys = ["Device ID", "SDK Version", "当前绑定账号", "联系我们"]
        userInfoValues.append(CloudPushSDK.getDeviceId())
        userInfoValues.append(CloudPushSDK.getVersion())
        userInfoValues.append("自定义账号")
        userInfoValues.append("Demo App相关问题\n 请在阿里旺旺或旺信中搜索淘宝旺旺群：\n 1360183878")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "userInfoCell"
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = userInfoValues[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
