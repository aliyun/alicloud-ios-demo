//
//  SQLiteManager.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/28.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "SQLiteManager.h"
#import "sqlite3.h"

@implementation SQLiteManager {
    NSString *_dbPath;
    sqlite3 *db;
}

- (void)init_datebase {
    // 查找数据文件位置和目标位置
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"mpush.sqlite"];

    // 存储数据文件位置，方便后期使用
    _dbPath = database_path;

    // 如果数据文件不存在则拷贝工程目录下的mpush.sqlite 到指定位置
    if (![[NSFileManager defaultManager] fileExistsAtPath:database_path]) {
        NSString *preloadURL = [[NSBundle mainBundle] pathForResource:@"mpush" ofType:@"sqlite"];
        NSError* err = nil;

        if (![[NSFileManager defaultManager] copyItemAtPath: preloadURL toPath:database_path error:&err]) {
            NSLog(@"数据文件拷贝失败");
        }
    }
}

// 执行SQL语句
- (void)excute:(NSString *)sql {
    [self init_datebase];

    NSLog(@"@数据库路径：%@", _dbPath);

    // 发起连接
    if (sqlite3_open([_dbPath UTF8String], &db) != SQLITE_OK) {
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

#pragma mark - Message

- (void)insertMessage:(PushMessage *)model {
    [self init_datebase];

    NSLog(@"@数据库路径：%@", _dbPath);

    if (sqlite3_open([_dbPath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败");
    } else {
        NSString *sqlStr = @"INSERT INTO PUSHMESSAGE (TITLE, CONTENT) VALUES (?, ?)";
        sqlite3_stmt *statement;
        //预编译之
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {

            //注入参数
            sqlite3_bind_text(statement, 1, [model.messageTitle UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [model.messageContent UTF8String], -1, NULL);
            // 执行SQL
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"插入数据失败。");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
}

- (void)removeMessage:(PushMessage *)model {
    NSString *deleteSQL = [NSString stringWithFormat:
                               @"DELETE FROM PUSHMESSAGE WHERE ID = '%i'",model.messageId];
    [self excute:deleteSQL];
}

- (NSMutableArray *)allMessages {
    [self init_datebase];

    NSLog(@"@数据库路径：%@", _dbPath);

    NSMutableArray* returnMsg = [[NSMutableArray alloc] init];
    if (sqlite3_open([_dbPath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    } else {
        NSString *sqlQuery = @"SELECT * FROM PUSHMESSAGE ORDER BY ID DESC";
        sqlite3_stmt * statement;

        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                PushMessage *tempEntity = [[PushMessage alloc] init];

                tempEntity.messageId = sqlite3_column_int(statement, 0);
                tempEntity.messageTitle = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                tempEntity.messageContent = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                [returnMsg addObject:tempEntity];
                NSLog(@"id:%i  messageTitle:%@ messageContent:%@",tempEntity.messageId, tempEntity.messageTitle, tempEntity.messageContent);
            }
        }
        sqlite3_close(db);
    }
    return returnMsg;
}

#pragma mark - tag

- (void)insertTag:(SettingTag *)tag {
    [self init_datebase];

    NSLog(@"@数据库路径：%@", _dbPath);
    NSString *sqlStr = @"INSERT INTO SETTINGTAGS (TAGNAME, TAGTYPE, TAGALIAS) VALUES (?, ?, ?)";

    if (sqlite3_open([_dbPath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败");
    } else {
        sqlite3_stmt *statement;
        //预编译之
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {

            //注入参数
            sqlite3_bind_text(statement, 1, [tag.tagName UTF8String], -1, NULL);
            sqlite3_bind_int(statement, 2, tag.tagType);
            if (tag.tagType == 3) {
                sqlite3_bind_text(statement, 3, [tag.tagAlias UTF8String], -1, NULL);
            }
            // 执行SQL
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"插入数据失败。");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
}

- (void)removeTag:(SettingTag *)tag {
    [self init_datebase];

    NSString *deleteSQL = [NSString stringWithFormat:
                               @"DELETE FROM SETTINGTAGS WHERE ID = '%i'", tag.tagId];
    [self excute:deleteSQL];
}

- (NSMutableArray *)allAliasTags {
    return [self allTagsWith:3];
}

- (NSMutableArray *)allAccountTags {
    return [self allTagsWith:2];
}

/// allTags
/// - Parameter type: 0 aliasTag  1 accountTag
- (NSMutableArray *)allTagsWith:(int)type {
    [self init_datebase];

    NSMutableArray* returnTags = [[NSMutableArray alloc] init];
    if (sqlite3_open([_dbPath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    } else {
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM SETTINGTAGS WHERE TAGTYPE = %d", type];
        sqlite3_stmt * statement;

        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                SettingTag *tag = [[SettingTag alloc] init];
                tag.tagId = sqlite3_column_int(statement, 0);
                tag.tagName = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                tag.tagType = sqlite3_column_int(statement, 2);
                if (type == 0) {
                    tag.tagAlias = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                }
                [returnTags addObject:tag];
                NSLog(@"id:%i  tagName:%@ tagType:%i",tag.tagId, tag.tagName, tag.tagType);
            }
        }
        sqlite3_close(db);
    }
    return returnTags;
}

@end
