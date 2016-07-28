//
//  LZLPersonalViewController.swift
//  mpush_swift_demo
//
//  Created by fuyuan.lfy on 16/7/25.
//  Copyright © 2016年 alibaba.qa. All rights reserved.
//

import UIKit
import MPushSDK

class LZLPersonalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var personalDataTableView: UITableView!
    var personalDataItems : [LZLPersonalData] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.personalDataItems = []
        self.loadInitialData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalDataItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "personalDataCell"
        let cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier)
        cell.textLabel?.text = personalDataItems[indexPath.row].itemName
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let tappedItem = self.personalDataItems[indexPath.row]
        MsgToolBox.showAlert(tappedItem.itemName, content: tappedItem.itemValue)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     *  初始化一些个人数据，类似DeviceID之类的东西
     */
    func loadInitialData() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        let deviceId = LZLPersonalData()
        deviceId.itemName = "Device ID"
        deviceId.itemValue = CloudPushSDK.getDeviceId()
        
        let sdkVersion = LZLPersonalData()
        sdkVersion.itemName = "CloudPush SDK Version"
        sdkVersion.itemValue = CloudPushSDK.getVersion()
        
        let bindAccount = LZLPersonalData()
        bindAccount.itemName = "当前绑定账号"
        bindAccount.itemValue = userDefaults.stringForKey("bindAccount") == nil ? "当前设备未绑定任何账号" : userDefaults.stringForKey("bindAccount")!
        
        let contactUs = LZLPersonalData()
        contactUs.itemName = "联系我们"
        contactUs.itemValue = "Demo App相关问题\n 请在阿里旺旺或旺信中搜索淘宝旺旺群：\n 1360183878"
        
        self.personalDataItems.append(contactUs)
        self.personalDataItems.append(deviceId)
        self.personalDataItems.append(sdkVersion)
        self.personalDataItems.append(bindAccount)
        
        self.personalDataTableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
