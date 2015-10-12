//
//  ALBBMANLog.h
//   
//
//  Created by 郭天 on 15/3/17.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

/*!
 @header ALBBMANLog.h
 @abstract Created by 郭天 on 14/11/25
 */
#import <Foundation/Foundation.h>

/*!
 @class
 @abstract 辅助打印log
 */
extern BOOL isEnableMANLog;

@interface ALBBMANLog : NSObject

/*!
 @method
 @abstract 开启log
 */
+ (void)enableLog;
/*!
 @method
 @abstract 打印debug信息
 */
+ (void)LogD:(NSString *)format, ...;
/*!
 @method
 @abstract 打印error信息
 */
+ (void)LogE:(NSString *)format, ...;
@end
