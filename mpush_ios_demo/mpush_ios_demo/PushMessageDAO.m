//
//  PushMessageDAO.m    数据持久层
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/4/1.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "PushMessageDAO.h"

@implementation PushMessageDAO

-(void) init_datebase {
    
    // 查找数据文件位置和目标位置
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"ued.sqlite"];
    
    // 存储数据文件位置，方便后期使用
    self.db_path = database_path;
    
    // 如果数据文件不存在则拷贝工程目录下的ued.sqlite 到指定位置
    if (![[NSFileManager defaultManager] fileExistsAtPath:database_path]) {
        NSString *preloadURL = [[NSBundle mainBundle] pathForResource:@"ued" ofType:@"sqlite"];
        NSError* err = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtPath: preloadURL toPath:database_path error:&err]) {
            NSLog(@"数据文件拷贝失败");
        }
    }
}

// 执行SQL语句
-(void) excute:(NSString *)sql {
    
    [self init_datebase];
    
    NSLog(@"@数据库路径：%@", self.db_path);
    
    // 发起连接
    if (sqlite3_open([self.db_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    } else {    //连接成功，执行sql
        char *err;
        if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"SQL执行失败，原因'%s'", err);
        } else {
            NSLog(@"SQL执行成功~");
        }
        sqlite3_close(db);
    }
}

-(void) insert:(LZLPushMessage *)model {
    [self init_datebase];
    
    NSLog(@"@数据库路径：%@", self.db_path);
    
    if (sqlite3_open([self.db_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败");
    } else {
        NSString *sqlStr = @"INSERT INTO PUSHMESSAGE (CONTENT, ISREAD) VALUES (?, ?)";
        sqlite3_stmt *statement;
        //预编译之
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {

            //注入参数
            sqlite3_bind_text(statement, 1, [model.messageContent UTF8String], -1, NULL);
            sqlite3_bind_int(statement, 2, model.isRead?1:0);
            // 执行SQL
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"插入数据失败。");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    
}

-(void) update:(LZLPushMessage *)model {
    NSString *updateSQL = [NSString stringWithFormat:
                               @"UPDATE PUSHMESSAGE SET ISREAD = '%i' WHERE ID = '%i'", model.isRead?1:0, model.id];
    [self excute:updateSQL];
}

-(void) remove:(LZLPushMessage *)model {
    NSString *deleteSQL = [NSString stringWithFormat:
                               @"DELETE FROM PUSHMESSAGE WHERE ID = '%i'",model.id];
    [self excute:deleteSQL];
}

-(NSMutableArray*) selectAll {
    
    [self init_datebase];
    
    NSLog(@"@数据库路径：%@", self.db_path);
    
    NSMutableArray* returnMsg = [[NSMutableArray alloc] init];
    if (sqlite3_open([self.db_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    } else {
        NSString *sqlQuery = @"SELECT * FROM PUSHMESSAGE ORDER BY ID DESC";
        sqlite3_stmt * statement;
        
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                LZLPushMessage *tempEntity = [[LZLPushMessage alloc] init];
                
                tempEntity.id = sqlite3_column_int(statement, 0);
                tempEntity.messageContent = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                tempEntity.isRead = sqlite3_column_int(statement, 2)==1?YES:NO;
                [returnMsg addObject:tempEntity];
                NSLog(@"id:%i  message:%@ isRead:%hhd",tempEntity.id, tempEntity.messageContent, tempEntity.isRead);
            }
        }
        sqlite3_close(db);
    }
    return returnMsg;
}

@end
