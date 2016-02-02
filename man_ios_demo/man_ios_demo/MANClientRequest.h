//
//  MANClientRequest.h
//  man_ios_demo
//
//  Created by nanpo.yhl on 15/10/10.
//  Copyright (c) 2015年 com.aliyun.mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlicloudMobileAnalitics/ALBBMAN.h>

@interface MANClientRequest : NSObject

@property(nonatomic,strong)NSMutableURLRequest *request;
@property(nonatomic,strong)NSURLConnection *connection;
@property(nonatomic,strong)NSMutableData *mutableData;
@property(nonatomic,strong)ALBBMANNetworkHitBuilder *bulider;

@end
