//
//  ALBBMASNetworkErrorInfo.h
//  ALBB_MAS_IOS_SDK
//
//  Created by 郭天 on 15/5/27.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBBMASNetworkErrorInfo : NSObject

@property (nonatomic, strong)NSMutableDictionary *properties;

- (instancetype)init:(NSMutableDictionary *)properties;
- (ALBBMASNetworkErrorInfo *)withExtraInfoKey:(NSString *)key value:(NSString *)value;

@end
