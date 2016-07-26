//
//  LZLSettingsViewController.swift
//  mpush_swift_demo
//
//  Created by fuyuan.lfy on 16/7/25.
//  Copyright © 2016年 alibaba.qa. All rights reserved.
//

import UIKit
import AlicloudUtils

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
    
    @IBAction func userBindAccount(sender: AnyObject) {
    }
    
    @IBAction func antiBindAccount(sender: AnyObject) {
    }
    
    @IBAction func userBindTagToDev(sender: AnyObject) {
    }

    @IBAction func userUnbindTagFromDev(sender: AnyObject) {
    }
    
    @IBAction func userBindTagToAccount(sender: AnyObject) {
    }
    
    @IBAction func userUnbindTagFromAccount(sender: AnyObject) {
    }
    
    @IBAction func userBindTagToAlias(sender: AnyObject) {
    }
    
    @IBAction func userUnbindTagFromAlias(sender: AnyObject) {
    }
    
    @IBAction func userListTags(sender: AnyObject) {
    }
    
    @IBAction func userAddAlias(sender: AnyObject) {
    }
    
    @IBAction func userListAliases(sender: AnyObject) {
    }
    
    @IBAction func userRemoveAlias(sender: AnyObject) {
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
