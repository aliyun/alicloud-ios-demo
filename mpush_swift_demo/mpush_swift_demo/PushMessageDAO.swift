//
//  PushMessageDAO.swift
//  mpush_swift_demo
//
//  Created by fuyuan.lfy on 16/7/26.
//  Copyright © 2016年 alibaba.qa. All rights reserved.
//

import UIKit
import SQLite
import AliCloudPush

let DBFILE_NAME = "ued.sqlite"

class PushMessageDAO: NSObject {
    var db: Connection?
    var db_path: String? // 数据文件位置
    // 初始化数据库
    func init_database() {
        // 查找数据文件位置和目标位置
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documents = paths[0]
        let database_path = documents + "/" + DBFILE_NAME
        // 存储数据文件位置，方便后期使用
        self.db_path = database_path
        
        // 如果数据文件不存在则拷贝工程目录下的ued.sqlite 到指定位置
        if !NSFileManager.defaultManager().fileExistsAtPath(database_path) {
            let preloadURL = NSBundle.mainBundle().pathForResource("ued", ofType: "sqlite");
            
            do {
                try NSFileManager.defaultManager().copyItemAtPath(preloadURL!, toPath: database_path)
            } catch {
                print("数据文件拷贝失败")
            }
        }
    }
    
    
    // 插入一条消息
    func insert(model: LZLPushMessage) {
        self.openDatabase()
        let messages = Table("PUSHMESSAGE")
        let content = Expression<String>("CONTENT")
        let isRead = Expression<Bool>("ISREAD")
        
        do {
            try db!.run(messages.insert(content <- model.messageContent, isRead <- model.isRead))
        } catch {
            print("数据插入失败")
        }
        // 查看插入的数据
        for message in try! db!.prepare(messages) {
            print("CONTENT: \(message[content]), ISREAD: \(message[isRead])")
        }
    }
    
    // 删除一条消息
    func remove(model: LZLPushMessage) {
        self.openDatabase()
        let messages = Table("PUSHMESSAGE")
        let messageId = Expression<Int>("ID")
        let record = messages.filter(messageId == model.id)
        
        do {
            try db!.run(record.delete())
        } catch {
            print("删除数据失败")
        }
    }
    
    // 更新一条消息
    func update(model: LZLPushMessage) {
        self.openDatabase()
        let messages = Table("PUSHMESSAGE")
        let messageId = Expression<Int>("ID")
        let record = messages.filter(messageId == model.id)
        let isRead = Expression<Bool>("ISREAD")
        
        do {
            try db!.run(record.update(isRead <- model.isRead))
        } catch {
            print("更新数据失败")
        }
    }
    
    // 查询全部消息
    func selectAll() -> Array<LZLPushMessage> {
        self.openDatabase()
        let messages = Table("PUSHMESSAGE")
        let messageId = Expression<Int>("ID")
        let content = Expression<String>("CONTENT")
        let isRead = Expression<Bool>("ISREAD")
        var resMessages = Array<LZLPushMessage>()
        do {
            let query = messages.select(messages[*]).order(messageId.desc)
            for row in try db!.prepare(query) {
                let message = LZLPushMessage(id: row[messageId], messageContent: row[content], isRead: row[isRead])
                resMessages.append(message)
            }
        } catch {
            print("查询消息失败")
        }
        return resMessages
    }
    
    func openDatabase() {
        self.init_database()
        assert(self.db_path != nil, "数据库路径为空")
        print("数据库路径：\(self.db_path)")
        do {
            self.db = try Connection(self.db_path!)
        } catch {
            assert(false, "数据库打开失败")
        }
    }
}
