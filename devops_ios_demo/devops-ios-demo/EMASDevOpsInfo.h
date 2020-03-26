//
//  EMASDevOpsInfo.h
//  devops-ios-demo
//
//  Created by 魏晓堃 on 2019/12/12.
//  Copyright © 2019 魏晓堃. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMASDevOpsInfo : NSObject

+ (EMASDevOpsInfo *)shareInstance;

@property(nonatomic, copy) NSString *ip;                // 客户端IP地址
@property(nonatomic, copy) NSString *proxyIp;           // 代理服务器地址
@property(nonatomic, copy) NSString *ttid;              // 渠道号
@property(nonatomic, copy) NSString *identifier;        // appkey@android 或 appkey@iphoneos
@property(nonatomic, copy) NSString *utdid;             // UTDID
@property(nonatomic, copy) NSString *brand;             // 设备品牌
@property(nonatomic, copy) NSString *model;             // 设备机型
@property(nonatomic, copy) NSString *os;                // 系统名(android/iOS)
@property(nonatomic, copy) NSString *osVersion;         // OS版本
@property(nonatomic, copy) NSString *apiLevel;          // OS API级别，安卓特有
@property(nonatomic, copy) NSString *appVersion;        // 应用版本
@property(nonatomic, copy) NSString *arch;              // 客户端架构参数，示例：armv7、arm64
@property(nonatomic, copy) NSString *netStatus;         // 网络状态。2G-1, 3G-2, 4G-3, 5G-4, WIFI-10
@property(nonatomic, copy) NSString *locale;            // 语言选项
@property(nonatomic, copy) NSString *md5Sum;            // 当前包的MD5值

- (NSDictionary *)converToParmaters;

@end

NS_ASSUME_NONNULL_END
