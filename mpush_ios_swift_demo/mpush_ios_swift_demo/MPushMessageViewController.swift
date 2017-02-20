//
//  MPushMessageViewController.swift
//  mpush_ios_swift_demo
//
//  Created by junmo on 16/10/23.
//  Copyright © 2016年 junmo. All rights reserved.
//

import UIKit


class MPushMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mpushMessageTableView: UITableView!
    var pushMessage : NSMutableArray?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mpushMessageTableView.delegate = self
        mpushMessageTableView.dataSource = self
        pushMessage = NSMutableArray.init()
        mpushMessageTableView.addPullToRefresh(actionHandler: {
            self.refreshTable()
            
        }, withBackgroundColor: UIColor.init(red: 0.251, green: 0.663, blue: 0.827, alpha: 1), withPullToRefreshHeightShowed: 1)
        //Customize pulltorefresh text colors
        mpushMessageTableView.pullToRefreshView.textColor = UIColor.white
        mpushMessageTableView.pullToRefreshView.textFont = UIFont(name: "OpenSans-Semibold", size: 16)
        // Set fontawesome icon
        mpushMessageTableView.pullToRefreshView.setFontAwesomeIcon("icon-refresh")
        //Set titles
        mpushMessageTableView.pullToRefreshView.setTitle("Pull", forState: UInt(KoaPullToRefreshStateStopped))
        //Hide scroll indicator
        mpushMessageTableView.showsVerticalScrollIndicator = false
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mpushMessageTableView.pullToRefreshView.startAnimating()
        mpushMessageTableView.pullToRefreshView.perform(#selector(mpushMessageTableView.pullToRefreshView.stopAnimating) , with: nil, afterDelay: 1)
        refreshTable()
        
    }
    
    func refreshTable() {
        
        let dao: PushMessageDAO = PushMessageDAO.init();
        pushMessage = dao.selectAll()
        mpushMessageTableView.reloadData()
        mpushMessageTableView.perform(#selector(mpushMessageTableView.reloadData), with: nil, afterDelay: 1.5)
        
        mpushMessageTableView.pullToRefreshView.perform(#selector(mpushMessageTableView.pullToRefreshView.stopAnimating), with: nil, afterDelay: 1.5)
   
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //================= Table View Method ====================================
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //删除cell
        if editingStyle == .delete {
            
            // 数据库中删除该条记录
            let dao : PushMessageDAO = PushMessageDAO.init()
            dao.remove(pushMessage!.object(at: indexPath.row) as! LZLPushMessage)
            pushMessage!.removeObject(at: indexPath.row)//数据源中剔除记录
            
            //MARK: 此处方法有错误
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadSections(NSIndexSet.init(index: 0) as IndexSet, with: .none)
        }
    }
    
    //MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pushMessage!.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier = "pushMessageCell";
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        
        let tablecell: LZLPushMessage = pushMessage!.object(at: indexPath.row) as! LZLPushMessage
        
        cell.textLabel!.text = tablecell.messageContent
        
        if tablecell.isRead {
            cell.accessoryType = .checkmark
            tableView.deselectRow(at: indexPath, animated: true)
            
        } else {
            cell.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let tappedItem :LZLPushMessage = pushMessage?.object(at: indexPath.row) as! LZLPushMessage
        
        if (tappedItem.isRead) {
            
        } else {
            
            tappedItem.isRead = true;
            let dao : PushMessageDAO = PushMessageDAO.init()
            
            dao.update(tappedItem)
            
            refreshTable()
            
            
        }
        
    }
    
}

