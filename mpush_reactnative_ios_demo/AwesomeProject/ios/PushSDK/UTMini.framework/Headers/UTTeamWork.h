//
//  UTTeamWork.h
//  UTMini
//
//  Created by ljianfeng on 2019/9/29.
//  Copyright © 2019 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UTTeamWork : NSObject
/**
 * @brief            自定义https上传域名
 *
 * @param     url    指定的https上传域名，比如以https://开头
 *
 * @warning   调用说明:需要在初始化UT之前调用(setAppkey之前)
 */
+ (void)setHttpsUploadUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
