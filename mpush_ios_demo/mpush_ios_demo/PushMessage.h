//
//  PushMessage.h    用于处理推送的消息的Entity
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/4/1.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushMessage : NSObject

@property int messageId;
@property NSString *messageTitle;
@property NSString *messageContent;

@end
