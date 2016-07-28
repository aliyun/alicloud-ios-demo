//
//  LZLSettingsViewController.swift
//  mpush_swift_demo
//
//  Created by fuyuan.lfy on 16/7/25.
//  Copyright © 2016年 alibaba.qa. All rights reserved.
//

import UIKit
import AliCloudPush

class LZLSettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userAccount: UITextField!
    @IBOutlet weak var userLabel: UITextField!
    @IBOutlet weak var userAlias: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userAccount.delegate = self
        userLabel.delegate = self
        userAlias.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 点击背景，键盘隐藏
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 点击键盘return，键盘隐藏
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    /**
     *  绑定账号
     *
     *  @param sender
     */
    @IBAction func userBindAccount(sender: AnyObject) {
        if userAccount.text?.characters.count > 0 {
            // 用户按下按钮&&输入了准备绑定的帐户名称
            CloudPushSDK.bindAccount(userAccount.text, withCallback: {(res) in
                if res.success {
                    print("==================> 绑定账号成功")
                    
                    // 切回主线程，防止crash
                    MsgToolBox.showAlert("温馨提示", content: "账号绑定成功")
                    self.clearInput()
                    
                    // 持久化已绑定的数据
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setObject(self.userAccount.text!, forKey: "bindAccount")
                    userDefaults.synchronize()
                } else {
                    print("==================> 绑定账号失败")
                    MsgToolBox.showAlert("温馨提示", content: "账号绑定失败, error: \(res.error)")
                }
            })
            userAccount.resignFirstResponder()
        } else {
            MsgToolBox.showAlert("温馨提示", content: "请输入账户名! ")
        }
    }
    
    /**
     *  解绑账号
     *
     *  @param sender
     */
    @IBAction func antiBindAccount(sender: AnyObject) {
        CloudPushSDK.unbindAccount({(res) in
            if res.success {
                print("解绑账号成功")
                
                // 切回主线程，防止crash
                MsgToolBox.showAlert("温馨提示", content: "账号解绑成功")
                self.clearInput()
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(nil, forKey: "bindAccount")
                userDefaults.synchronize()
            } else {
                print("解绑账号失败")
                MsgToolBox.showAlert("温馨提示", content: "账号解绑失败, error: \(res.error)")
            }
        })
        userAccount.resignFirstResponder()
    }
    
    /**
     *  绑定设备标签
     *
     *  @param sender
     */
    @IBAction func userBindTagToDev(sender: AnyObject) {
        let tagArray = getTagArray()
        if (tagArray == nil) {
            return
        }
        CloudPushSDK.bindTag(1, withTags: tagArray, withAlias: nil, withCallback: {(res) in
            if res.success {
                print("绑定设备标签成功")
                MsgToolBox.showAlert("温馨提示", content: "设备标签绑定成功")
                self.clearInput()
            } else {
                print("绑定设备标签失败, 错误: \(res.error)")
                MsgToolBox.showAlert("温馨提示", content: "设备标签绑定失败, error: \(res.error)")
            }
        })
    }

    /**
     *  解绑设备标签
     *
     *  @param sender
     */
    @IBAction func userUnbindTagFromDev(sender: AnyObject) {
        let tagArray = getTagArray()
        if tagArray == nil {return}
        CloudPushSDK.unbindTag(1, withTags: tagArray, withAlias: nil, withCallback: {(res) in
            if res.success {
                print("解绑设备标签成功")
                MsgToolBox.showAlert("温馨提示", content: "解绑设备标签成功")
                self.clearInput()
            } else {
                print("解绑设备标签失败, 错误: \(res.error)")
                MsgToolBox.showAlert("温馨提示", content: "解绑设备标签失败, error: \(res.error)")
            }
        })
    }
    
    /**
     *  绑定账号标签
     *
     *  @param sender
     */
    @IBAction func userBindTagToAccount(sender: AnyObject) {
        let tagArray = getTagArray()
        if tagArray == nil {return}
        CloudPushSDK.bindTag(2, withTags: tagArray, withAlias: nil, withCallback: {(res) in
            if res.success {
                print("绑定账号标签成功")
                MsgToolBox.showAlert("温馨提示", content: "账号标签绑定成功")
                self.clearInput()
            } else {
                print("绑定账号标签失败, 错误: \(res.error)")
                MsgToolBox.showAlert("温馨提示", content: "账号标签绑定失败, error: \(res.error)")
            }
        })
    }
    
    /**
     *  解绑账号标签
     *
     *  @param sender
     */
    @IBAction func userUnbindTagFromAccount(sender: AnyObject) {
        let tagArray = getTagArray()
        if tagArray == nil {return}
        CloudPushSDK.unbindTag(2, withTags: tagArray, withAlias: nil, withCallback: {(res) in
            if res.success {
                print("解绑账号标签成功")
                MsgToolBox.showAlert("温馨提示", content: "解绑账号标签成功")
                self.clearInput()
            } else {
                print("解绑账号标签失败, 错误: \(res.error)")
                MsgToolBox.showAlert("温馨提示", content: "解绑账号标签失败, error: \(res.error)")
            }
        })
    }
    
    /**
     *  绑定别名标签
     *
     *  @param sender
     */
    @IBAction func userBindTagToAlias(sender: AnyObject) {
        let tagArray = getTagArray()
        if tagArray == nil {return}
        let aliasString = userAlias.text
        if aliasString == nil || aliasString!.isEmpty {
            MsgToolBox.showAlert("温馨提示", content: "请输入别名")
            return
        }
        CloudPushSDK.bindTag(3, withTags: tagArray, withAlias: aliasString, withCallback: {(res) in
            if res.success {
                print("绑定别名标签成功")
                MsgToolBox.showAlert("温馨提示", content: "别名标签绑定成功")
                self.clearInput()
            } else {
                print("绑定别名标签失败, 错误: \(res.error)")
                MsgToolBox.showAlert("温馨提示", content: "别名标签绑定失败, error: \(res.error)")
            }
        })
    }
    
    /**
     *  解绑别名标签
     *
     *  @param sender
     */
    @IBAction func userUnbindTagFromAlias(sender: AnyObject) {
        let tagArray = getTagArray()
        if tagArray == nil {return}
        let aliasString = userAlias.text
        if aliasString == nil || aliasString!.isEmpty {
            MsgToolBox.showAlert("温馨提示", content: "请输入别名")
            return
        }
        CloudPushSDK.unbindTag(3, withTags: tagArray, withAlias: aliasString, withCallback: {(res) in
            if res.success {
                print("解绑别名标签成功")
                MsgToolBox.showAlert("温馨提示", content: "别名标签解绑成功")
                self.clearInput()
            } else {
                print("解绑别名标签失败, 错误: \(res.error)")
                MsgToolBox.showAlert("温馨提示", content: "别名标签解绑失败, error: \(res.error)")
            }
        })
    }
    
    /**
     *  查询设备标签
     *
     *  @param sender
     */
    @IBAction func userListTags(sender: AnyObject) {
        CloudPushSDK.listTags(1, withCallback: {(res) in
            if res.success {
                print("查询设备标签成功, \(res.data)")
                MsgToolBox.showAlert("温馨提示", content: "查询设备标签成功, \(res.data)")
            } else {
                print("查询设备标签失败, 错误: \(res.error)")
                MsgToolBox.showAlert("温馨提示", content: "查询设备标签失败, error: \(res.error)")
            }
        })
    }
    
    /**
     *  添加设备别名
     *
     *  @param sender
     */
    @IBAction func userAddAlias(sender: AnyObject) {
        let aliasString = userAlias.text
        if aliasString == nil || aliasString!.isEmpty {
            MsgToolBox.showAlert("温馨提示", content: "请输入别名")
            return
        }
        CloudPushSDK.addAlias(aliasString) {res in
            if res.success {
                print("添加设备别名成功")
                MsgToolBox.showAlert("温馨提示", content: "添加设备别名成功")
                self.clearInput()
            } else {
                print("添加设备别名失败, 错误: \(res.error)")
                MsgToolBox.showAlert("温馨提示", content: "添加设备别名失败, error: \(res.error)")
            }
        }
    }
    
    /**
     *  查询设备别名
     *
     *  @param sender
     */
    @IBAction func userListAliases(sender: AnyObject) {
        CloudPushSDK.listAliases({res in
            if res.success {
                print("查询设备别名成功: \(res.data)")
                MsgToolBox.showAlert("温馨提示", content: "查询设备别名成功：\(res.data)")
            } else {
                print("查询设备别名失败, 错误: \(res.error)")
                MsgToolBox.showAlert("温馨提示", content: "查询设备别名失败, eroor: \(res.error)")
            }
        })
    }
    
    /**
     *  删除设备别名
     *
     *  @param sender
     */
    @IBAction func userRemoveAlias(sender: AnyObject) {
        let aliasString = userAlias.text
        if aliasString == nil || aliasString!.isEmpty {
            print("删除所有别名")
        }
        CloudPushSDK.removeAlias(aliasString, withCallback: {res in
            if res.success {
                print("删除设备别名成功")
                MsgToolBox.showAlert("温馨提示", content: "删除设备别名成功")
            } else {
                print("删除设备别名失败, 错误: \(res.error)")
                MsgToolBox.showAlert("温馨提示", content: "删除设备别名失败, error: \(res.error)")
            }
        })
    }
    
    /**
     *  获取标签数组
     *
     *  @return
     */
    func getTagArray() -> Array<String>? {
        let tag: String? = userLabel.text
        if tag != nil && !tag!.isEmpty {
            return tag?.componentsSeparatedByString(" ")
        } else {
            MsgToolBox.showAlert("温馨提示", content: "请输入标签")
            return nil
        }
    }
    
    func clearInput() {
        dispatch_async(dispatch_get_main_queue(), {
            self.userAccount.text = ""
            self.userLabel.text = ""
            self.userAlias.text = ""
        })
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
