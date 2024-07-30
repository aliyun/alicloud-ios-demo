//
//  SettingInfoModel.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingInfoModel : NSObject

@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *descripte;
@property(nonatomic, assign)BOOL switchIsOn;
@property(nonatomic, copy)NSString *cacheKey;

- (instancetype)initWithTitle:(NSString *)title descripte:(NSString *)descripte switchIsOn:(BOOL)isOn cacheKey:(NSString *)cacheKey;

@end

NS_ASSUME_NONNULL_END
