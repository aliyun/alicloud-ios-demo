//
//  LZLMessageViewController.swift
//  mpush_swift_demo
//
//  Created by fuyuan.lfy on 16/7/25.
//  Copyright © 2016年 alibaba.qa. All rights reserved.
//

import UIKit

class LZLMessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var pushMessageTableView: UITableView!
    var messages : [LZLPushMessage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let tappedItem = self.messages[indexPath.row]
        
        if !tappedItem.isRead {
            tappedItem.isRead = true
            let dao = PushMessageDAO()
            dao.update(tappedItem)
            self.refreshTable()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "pushMessageCell"
        let cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier)
        let curMessage = messages[indexPath.row]
        cell.textLabel?.text = curMessage.messageContent
        
        if curMessage.isRead {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 删除cell
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // 数据库中删除该条记录
            let dao = PushMessageDAO()
            dao.remove(messages[indexPath.row])
            self.messages.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func refreshTable() {
        let dao = PushMessageDAO()
        self.messages = dao.selectAll()
        self.pushMessageTableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.refreshTable()
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
