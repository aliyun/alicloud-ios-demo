//
//  PushMessageDAO.swift
//  mpush_ios_swift_demo
//
//  Created by mac on 2017/3/6.
//  Copyright © 2017年 junmo. All rights reserved.
//

import UIKit

class PushMessageDAO: NSObject {
    
    public var db: OpaquePointer? = nil
    // 数据文件位置
    public var db_path: NSString?
    
    // 初始化数据库
    public func init_datebase() {
        // 查找数据文件位置和目标位置
        let database_path: String = NSHomeDirectory() + "/Documents/ued.sqlite"
        // 存储数据文件位置，方便后期使用
        db_path = database_path as NSString?
        // 如果数据文件不存在,则拷贝工程目录下的ued.sqlite 到指定位置
        if !FileManager.default.fileExists(atPath: database_path) {
            let preloadURL = Bundle.main.path(forResource: "ued", ofType: "sqlite")
            do {
                try FileManager.default.copyItem(atPath:preloadURL!, toPath: database_path)
            } catch let error as NSError {
                print(error)//如果创建失败，error 会返回错误信息
            }
        }
    }
    
    // 执行SQL语句
    public func excute(sql: NSString) {
        init_datebase()
        //print("@数据库路径：\(db_path)")
        // 发起连接
        if sqlite3_open(db_path!.utf8String!, &db) != SQLITE_OK {
            sqlite3_close(db)
            print("数据库打开失败")
        } else {    //连接成功，执行sql
            
            let errmsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
            if sqlite3_exec(db, sql.utf8String, nil, nil, errmsg) != SQLITE_OK {
                sqlite3_close(db)
                print("SQL执行失败~" + String(describing: errmsg))
            } else {
                print("SQL执行成功~")
            }
            sqlite3_close(db)
        }
    }
    
    // 插入一条消息
    public func insert(model: RPushMessage) {
        init_datebase()
        if sqlite3_open(db_path!.utf8String, &db) != SQLITE_OK {
            sqlite3_close(db)
            assert(false, "数据库打开失败")
        } else {
            let sqlStr = "INSERT INTO PUSHMESSAGE (CONTENT, ISREAD) VALUES (?, ?)" as NSString
            var statement: OpaquePointer? = nil
            //预编译之
            if sqlite3_prepare_v2(db, sqlStr.utf8String, -1, &statement, nil) == SQLITE_OK {
                //注入参数
                sqlite3_bind_text(statement, 1, model.messageContent?.utf8String, -1, nil)
                sqlite3_bind_int(statement, 2, model.isRead! ? 1 : 0)
                // 执行SQL
                if sqlite3_step(statement) != SQLITE_DONE {
                    assert(false, "插入数据失败。")
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
    }
    
    // 删除一条消息
    public func remove(model: RPushMessage) {
        let deleteSQL: String = "DELETE FROM PUSHMESSAGE WHERE ID = " + String(describing: model.id!)
        self.excute(sql: deleteSQL as NSString)
    }
    
    // 更新一条消息
    public func update(model: RPushMessage) {
        let updateSQL: String = "UPDATE PUSHMESSAGE SET ISREAD = " + String(model.isRead! ? true : false) + " WHERE ID = " + String(describing: model.id)
        self.excute(sql: updateSQL as NSString)
    }
    
    // 查询全部消息
    public func selectAll() -> NSMutableArray {
        
        init_datebase()
        //print("@数据库路径：\(db_path)")
        let returnMsg = NSMutableArray()
        if sqlite3_open(db_path!.utf8String!, &db) != SQLITE_OK {
            sqlite3_close(db)
            print("数据库打开失败")
        } else {
            let sqlQuery = "SELECT * FROM PUSHMESSAGE ORDER BY ID DESC"
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, sqlQuery, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let tempEntity: RPushMessage = RPushMessage()
                    tempEntity.id = sqlite3_column_int(statement, 0)
                    var UInt8Text:  UnsafePointer<UInt8> = sqlite3_column_text(statement, 1)!
                    var Int8Text: UnsafePointer<Int8>? {
                        return withUnsafePointer(to: &UInt8Text) {
                            $0.withMemoryRebound(to: UnsafePointer.self, capacity: 1) {
                                $0.pointee
                            }
                        }
                    }
                    tempEntity.messageContent = NSString.init(utf8String: Int8Text!)
                    tempEntity.isRead = sqlite3_column_int(statement, 2) == 1 ? true : false
                    returnMsg.add(tempEntity)
                    print("id:" + String(describing: tempEntity.id!) + "  message:" + String(describing: tempEntity.messageContent!) + "  isRead:" + String(describing: tempEntity.isRead!))
                }
            }
            sqlite3_close(db)
        }
        return returnMsg
    }

}
