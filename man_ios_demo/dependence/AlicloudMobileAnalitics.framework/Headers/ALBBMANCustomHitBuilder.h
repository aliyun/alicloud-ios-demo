//
//  ALBBMANCustomHitBuilder.h
//   
//
//  Created by 郭天 on 15/3/5.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UTMini/UTCustomHitBuilder.h>
//#import "UTCustomHitBuilder.h"

@interface ALBBMANCustomHitBuilder : UTCustomHitBuilder

-(void) setProperty:(NSString *) pKey value:(NSString *) pValue;

-(void) setProperties:(NSDictionary *) pPageProperties;


-(void) setEventLabel:(NSString *) pEventId;

-(void) setEventPage:(NSString *) pPageName;

-(void) setDurationOnEvent:(long long) durationOnEvent;

@end
