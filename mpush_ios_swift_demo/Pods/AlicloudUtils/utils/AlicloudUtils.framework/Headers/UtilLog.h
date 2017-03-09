//
//  UtilLog.h
//  AlicloudUtils
//
//  Created by junmo on 16/11/24.
//  Copyright © 2016年 Ali. All rights reserved.
//

#ifndef UtilLog_h
#define UtilLog_h

@interface UtilLog : NSObject

+ (void)enableLog;

+ (BOOL)isLogEnabled;

#define UtilLogD(tag, frmt, ...)\
if ([UtilLog isLogEnabled]) {\
NSLog(@"[%@]-[D]: %@", tag, [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);\
}

#define UtilLogI(tag, frmt, ...)\
if ([UtilLog isLogEnabled]) {\
NSLog(@"[%@]-[I]: %@", tag, [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);\
}

#define UtilLogE(tag, frmt, ...)\
if ([UtilLog isLogEnabled]) {\
NSLog(@"[%@]-[E]: %@", tag, [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);\
}
@end

#endif /* UtilLog_h */
