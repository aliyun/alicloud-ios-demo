//
//  UTRestReq.h
//  UTSDK
//
//  Created by Alvin on 14-8-21.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#ifndef UTSDK_UTCrashRestReq_h
#define UTSDK_UTCrashRestReq_h

#import <Foundation/Foundation.h>

@interface UTCrashRestSendReq : NSObject

+(BOOL) sendLog:(NSObject *)aPageName eventId:(int) aEventId arg1:(NSString *) aArg1 arg2:(NSString *) aArg2 arg3:(NSString *) aArg3 args:(NSDictionary *) aArgs;

@end

#endif
