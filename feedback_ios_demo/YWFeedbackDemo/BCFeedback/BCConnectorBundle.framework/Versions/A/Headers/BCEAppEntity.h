//
//  WQEAppEntity.h
//  WQOpenSDK
//
//  Created by qinghua.liqh on 14-2-28.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCPluginConstants.h"

#define WQEAppEntity BCEAppEntity

@interface WQEAppEntity : NSObject
@property (nonatomic, assign) long appId;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, assign) long msgBoxId;
@property (nonatomic, strong) NSString *introduce;

@property (strong,nonatomic) NSString *appkey;
@property (strong,nonatomic) NSString *appsecret;
@property (strong,nonatomic) NSString *appVersion;

@property (strong,nonatomic) NSString *callbackUrl;
@property (strong,nonatomic) NSString *downloadUrl;
@property (nonatomic,assign) WQAppType appType;
@property (assign, nonatomic) long categoryId;
@property (assign, nonatomic) int devFlag;

@property (strong, nonatomic) NSString *localIcon;
@property (assign, nonatomic) int unreadCount;
@property (assign, nonatomic) BOOL showNewFlag;

- (id)initWithId:(long)appId;
@end
