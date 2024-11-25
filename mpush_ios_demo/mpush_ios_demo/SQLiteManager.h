//
//  SQLiteManager.h
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/28.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushMessage.h"
#import "SettingTag.h"

NS_ASSUME_NONNULL_BEGIN

@interface SQLiteManager : NSObject

#pragma mark - Message

- (void)insertMessage:(PushMessage *)model;

- (void)removeMessage:(PushMessage *)model;

- (NSMutableArray *)allMessages;

#pragma mark - Tag

- (void)insertTag:(SettingTag *)tag;

- (void)removeTag:(SettingTag *)tag;

- (NSMutableArray *)allAliasTags;

- (NSMutableArray *)allAccountTags;

@end

NS_ASSUME_NONNULL_END
