//
//  SettingInfoModel.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/26.
//

#import "SettingInfoModel.h"

@implementation SettingInfoModel

- (instancetype)initWithTitle:(NSString *)title descripte:(NSString *)descripte switchIsOn:(BOOL)isOn cacheKey:(NSString *)cacheKey {
    if (self = [super init]) {
        self.title = title;
        self.descripte = descripte;
        self.switchIsOn = isOn;
        self.cacheKey = cacheKey;
    }
    return self;
}

@end
