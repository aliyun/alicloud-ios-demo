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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //mpushMessageTableView.delegate = self
        //mpushMessageTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        return cell
    }
    
}

