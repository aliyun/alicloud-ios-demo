//
//  LZLPersonalViewController.swift
//  mpush_swift_demo
//
//  Created by fuyuan.lfy on 16/7/25.
//  Copyright © 2016年 alibaba.qa. All rights reserved.
//

import UIKit

class LZLPersonalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var personalDataTableView: UITableView!
    var personalDataItems : [LZLPersonalData] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
