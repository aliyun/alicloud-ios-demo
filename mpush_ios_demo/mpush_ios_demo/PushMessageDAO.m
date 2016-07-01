//
//  PushMessageDAO.m    数据持久层
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/4/1.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "PushMessageDAO.h"

@implementation PushMessageDAO

- (void)dealloc {
    
    if ( db ) {
        NSLog(@"@关闭数据库连接");
        sqlite3_close(db);
    }
}

-(void) init_datebase {
    
    if ( db ) {
        return;
    }
    
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
    
    NSLog(@"@数据库路径：%@", self.db_path);
    
    // 打开数据库连接
    if (sqlite3_open([self.db_path UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
    }
}

// 执行SQL语句
-(void) excute:(NSString *)sql {
    
    [self init_datebase];
    
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"SQL执行失败，原因'%s'", err);
    } else {
        NSLog(@"SQL执行成功~");
    }
}

-(void) insert:(LZLPushMessage *)model {
    
    [self init_datebase];
    
    NSString *sqlStr = @"INSERT INTO PUSHMESSAGE (CONTENT, ISREAD) VALUES (?, ?)";
    sqlite3_stmt *statement;
    //预编译之
    if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        
        //注入参数
        sqlite3_bind_text(statement, 1, [model.messageContent UTF8String], -1, NULL);
        sqlite3_bind_int(statement, 2, model.isRead?1:0);
        // 执行SQL
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"插入数据失败。");
        }
    }
    sqlite3_finalize(statement);
    
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
    
    NSMutableArray* returnMsg = [[NSMutableArray alloc] init];
    NSString *sqlQuery = @"SELECT * FROM PUSHMESSAGE ORDER BY ID DESC";
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            LZLPushMessage *tempEntity = [[LZLPushMessage alloc] init];
            
            tempEntity.id = sqlite3_column_int(statement, 0);
            tempEntity.messageContent = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
            tempEntity.isRead = sqlite3_column_int(statement, 2)==1?YES:NO;
            [returnMsg addObject:tempEntity];
            NSLog(@"id:%i  message:%@ isRead:%d",tempEntity.id, tempEntity.messageContent, tempEntity.isRead);
        }
    }
    return returnMsg;
}

@end
