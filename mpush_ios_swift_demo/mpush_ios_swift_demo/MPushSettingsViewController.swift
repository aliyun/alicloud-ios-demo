//
//  MPushSettingsViewController.swift
//  mpush_ios_swift_demo
//
//  Created by junmo on 16/10/23.
//  Copyright © 2016年 junmo. All rights reserved.
//

import UIKit

class MPushSettingsViewController: UIViewController,UITextFieldDelegate,UIAlertViewDelegate {

    @IBOutlet weak var userAccount: UITextField!
    @IBOutlet weak var userLabel: UITextField!
    @IBOutlet weak var userAlias: UITextField!
    
    // 点击背景，键盘隐藏
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 点击键盘return，键盘隐藏
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     *  获取标签数组
     *
     *  @return
     */
    func getTagArray() -> Array<Any> {
        let tagString = self.userLabel.text
        if (tagString?.characters.count)! > 0 {
            let tagArray = tagString?.components(separatedBy: "")
            return tagArray!
        } else {
            MsgToolBox.showAlert(title: "温馨提示", content: "请输入标签！")
            return []
        }
    }

    func clearInput() {
        DispatchQueue.main.async {
            self.userAccount.text = ""
            self.userLabel.text = ""
            self.userAlias.text = ""
        }
    }

    /**
     *  绑定账号
     *
     *  @param sender
     */
    @IBAction func userBindAccount(_ sender: Any) {
        if (self.userAccount.text?.characters.count)! > 0 {
            //用户按下按钮&&输入了准备绑定的帐户名称
            CloudPushSDK.bindAccount(self.userAccount.text!, withCallback: { (res: CloudPushCallbackResult?) in
                if (res?.success)! {
                    print("==================> 绑定账号成功")
                    //切回主线程，防止crash
                    MsgToolBox.showAlert(title: "温馨提示", content: "账号绑定成功")
                    self.clearInput()
                    //持久化已绑定的数据
                    let userDefaultes = UserDefaults.standard
                    userDefaultes.setValue(self.userAccount.text!, forKey: "bindAccount")
                    userDefaultes.synchronize()
                } else {
                    print("==================> 绑定账号失败")
                    MsgToolBox.showAlert(title: "温馨提示", content: "账号绑定失败" + String(describing: res?.error))
                }
            })
            self.userAccount.resignFirstResponder()
        } else {
            MsgToolBox.showAlert(title: "温馨提示", content: "请输入帐户名")
        }
    }
    
    /**
     *  解绑账号
     *
     *  @param sender
     */
    @IBAction func antiBindAccount(_ sender: Any) {
        
        CloudPushSDK.unbindAccount { (res: CloudPushCallbackResult?) in
            if (res?.success)! {
                print("解绑账号成功")
                //切回主线程，防止crash
                MsgToolBox.showAlert(title: "温馨提示", content: "账号解绑成功！")
                DispatchQueue.main.async {
                    self.clearInput()
                }
                let userDefaultes = UserDefaults.standard
                userDefaultes.setValue(nil, forKey: "bindAccount")
                userDefaultes.synchronize()
            } else {
                print("解绑账号失败")
                MsgToolBox.showAlert(title: "温馨提示", content: "账号解绑失败" + String(describing: res?.error))
            }
        }
        self.userAccount.resignFirstResponder()
    }

    /**
     *  绑定设备标签
     *
     *  @param sender
     */
    @IBAction func userBindTagToDev(_ sender: Any) {
        let tagArray = self.getTagArray()
        if !tagArray.isEmpty == false {
            return
        }
        CloudPushSDK.bindTag(1, withTags: tagArray, withAlias: nil) { (res: CloudPushCallbackResult?) in
            if (res?.success)! {
                print("绑定设备标签成功")
                MsgToolBox.showAlert(title: "温馨提示", content: "设备标签绑定成功！")
                DispatchQueue.main.async {
                    self.clearInput()
                }
            } else {
            print("绑定设备标签失败" + String(describing: res?.error))
              MsgToolBox.showAlert(title: "温馨提示", content: "设备标签绑定失败" + String(describing: res?.error))
            }
        }
    }
    
    /**
     *  解绑设备标签
     *
     *  @param sender
     */
    @IBAction func userUnbindTagFromDev(_ sender: Any) {
        let tagArray = self.getTagArray()
        if !tagArray.isEmpty == false {
            return
        }
        CloudPushSDK.unbindAccount { (res: CloudPushCallbackResult?) in
            if (res?.success)! {
                print("解绑设备标签成功")
                MsgToolBox.showAlert(title: "温馨提示", content: "解绑设备标签成功！")
                self.clearInput()
            } else {
                print("解绑设备标签失败" + String(describing: res?.error))
                MsgToolBox.showAlert(title: "温馨提示", content: "解绑设备标签失败" + String(describing: res?.error))
            }
        }
    }
  
    /**
     *  绑定账号标签
     *
     *  @param sender
     */
    @IBAction func userBindTagToAccount(_ sender: Any) {
        let tagArray = self.getTagArray()
        if !tagArray.isEmpty == false {
            return
        }
        CloudPushSDK.bindTag(2, withTags: tagArray, withAlias: nil) { (res: CloudPushCallbackResult?) in
            if (res?.success)! {
                print("绑定账号标签成功")
                MsgToolBox.showAlert(title: "温馨提示", content: "账号标签绑定成功！")
                self.clearInput()
            } else {
                print("绑定账号标签失败" + String(describing: res?.error))
                MsgToolBox.showAlert(title: "温馨提示", content: "账号标签绑定失败" + String(describing: res?.error))
            }
        }
    }

    /**
     *  解绑账号标签
     *
     *  @param sender
     */
    
    @IBAction func userUnbindTagFromAccount(_ sender: Any) {
        let tagArray = self.getTagArray()
        if !tagArray.isEmpty == false {
            return
        }
        CloudPushSDK.unbindTag(2, withTags: tagArray, withAlias: nil) { (res: CloudPushCallbackResult?) in
            if (res?.success)! {
                print("解绑账号标签成功")
                MsgToolBox.showAlert(title: "温馨提示", content: "解绑账号标签成功！")
                self.clearInput()
            } else {
                print("解绑账号标签失败" + String(describing: res?.error))
                MsgToolBox.showAlert(title: "温馨提示", content: "解绑账号标签失败" + String(describing: res?.error))
            }
        }
    }
 
    /**
     *  绑定别名标签
     *
     *  @param sender
     */
    @IBAction func userBindTagToAlias(_ sender: Any) {
        let tagArray = self.getTagArray()
        if !tagArray.isEmpty == false {
            return
        }
        let aliasString = self.userAlias.text!
        if aliasString.characters.count == 0 {
            MsgToolBox.showAlert(title: "温馨提示", content: "请输入别名")
            return
        }
        CloudPushSDK.bindTag(3, withTags: tagArray, withAlias: aliasString) { (res: CloudPushCallbackResult?) in
            if (res?.success)! {
                print("绑定别名标签成功")
                MsgToolBox.showAlert(title: "温馨提示", content: "别名标签绑定成功！")
                self.clearInput()
            } else {
                print("绑定别名标签失败" + String(describing: res?.error))
                MsgToolBox.showAlert(title: "温馨提示", content: "别名标签绑定失败" + String(describing: res?.error))
            }
        }
    }
    
    /**
     *  解绑别名标签
     *
     *  @param sender
     */
    @IBAction func userUnbindTagFromAlias(_ sender: Any) {
        let tagArray = self.getTagArray()
        if !tagArray.isEmpty == false {
            return
        }
        let aliasString = self.userAlias.text!
        if aliasString.characters.count == 0 {
            MsgToolBox.showAlert(title: "温馨提示", content: "请输入别名")
            return
        }
        CloudPushSDK.unbindTag(3, withTags: tagArray, withAlias: aliasString) { (res: CloudPushCallbackResult?) in
            if (res?.success)! {
                print("解绑别名标签成功")
                MsgToolBox.showAlert(title: "温馨提示", content: "别名标签解绑成功！")
                self.clearInput()
            } else {
                print("解绑别名标签失败" + String(describing: res?.error))
                MsgToolBox.showAlert(title: "温馨提示", content: "解绑别名标签绑定失败" + String(describing: res?.error))
            }
        }
    }

    /**
     *  查询设备标签
     *
     *  @param sender
     */
    @IBAction func userListTags(_ sender: Any) {
        CloudPushSDK.listAliases { (res: CloudPushCallbackResult?) in
            if (res?.success)! {
                print("查询设备标签成功" + String(describing: res?.data))
                MsgToolBox.showAlert(title: "温馨提示", content: "查询设备标签成功！" + String(describing: res?.data))
                self.clearInput()
            } else {
                print("查询设备标签失败" + String(describing: res?.error))
                MsgToolBox.showAlert(title: "温馨提示", content: "查询设备标签失败" + String(describing: res?.error))
            }
        }
    }
    
    /**
     *  添加设备别名
     *
     *  @param sender
     */
    @IBAction func userAddAlias(_ sender: Any) {
        let aliasString = self.userAlias.text!
        if  aliasString.characters.count == 0 {
           MsgToolBox.showAlert(title: "温馨提示", content: "请输入别名！")
            return
        }
        CloudPushSDK.addAlias(aliasString) { (res: CloudPushCallbackResult?) in
            if (res?.success)! {
                print("添加设备别名成功")
                MsgToolBox.showAlert(title: "温馨提示", content: "添加设备别名成功！")
                self.clearInput()
            } else {
                print("添加设备别名失败，错误:" + String(describing: res?.error))
                MsgToolBox.showAlert(title: "温馨提示", content: "添加设备别名失败" + String(describing: res?.error))
            }
        }
    }
    
    /**
     *  删除设备别名
     *
     *  @param sender
     */
    @IBAction func userRemoveAlias(_ sender: Any) {
        let aliasString = self.userAlias.text!
        if  aliasString.characters.count == 0 {
            print("删除全部别名")
        }
        CloudPushSDK.removeAlias(aliasString) { (res: CloudPushCallbackResult?) in
            if (res?.success)! {
                print("删除设备别名成功")
                MsgToolBox.showAlert(title: "温馨提示", content: "删除设备别名成功！")
                self.clearInput()
            } else {
                print("删除设备别名失败，错误:" + String(describing: res?.error))
                MsgToolBox.showAlert(title: "温馨提示", content: "删除设备别名失败," + String(describing: res?.error))
            }
        }
    }

    /**
     *  查询设备别名
     *
     *  @param sender
     */
    @IBAction func userListAliases(_ sender: Any) {
        CloudPushSDK.listAliases { (res: CloudPushCallbackResult?) in
            if (res?.success)! {
                print("查询设备别名成功" + String(describing: res?.data))
                MsgToolBox.showAlert(title: "温馨提示", content: "查询设备别名成功" + String(describing: res?.data))
                self.clearInput()
            } else {
                print("查询设备别名失败，错误:" + String(describing: res?.error))
                MsgToolBox.showAlert(title: "温馨提示", content: "查询设备别名失败," + String(describing: res?.error))
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {    }
 
    func alertMsg(title: String, content: String) {
        let alertView : UIAlertView = UIAlertView.init(title: title, message: content, delegate: self, cancelButtonTitle: "Cencel", otherButtonTitles: "OK", "")
        alertView.show()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.userAccount.delegate = self;
        self.userLabel.delegate = self;
        self.userAlias.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
