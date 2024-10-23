//
//  PushMessageDAO.h
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/4/1.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushMessage.h"
#import "sqlite3.h"

@interface PushMessageDAO : NSObject {
    sqlite3 *db;
}

// 数据文件位置
@property (weak, nonatomic) NSString *db_path;

// 初始化数据库
- (void)init_datebase;

// 插入一条消息
- (void)insert:(PushMessage *)model;

// 删除一条消息
- (void)remove:(PushMessage *)model;

// 更新一条消息
// -(void) update:(PushMessage *)model;

// 查询全部消息
-(NSMutableArray*)selectAll;

@end
