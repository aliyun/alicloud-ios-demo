//
//  HttpdnsRequest.h
//  Dpa-Httpdns-iOS
//
//  Created by zhouzhuo on 5/1/15.
//  Copyright (c) 2015 zhouzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpdnsRequest : NSObject<NSURLConnectionDataDelegate>

-(NSMutableArray *)lookupAllHostsFromServer:(NSString *)hostsString error:(NSError **)error;

+(void)notifyRequestFailed;

+(void)requestServerTimeStamp;
@end
