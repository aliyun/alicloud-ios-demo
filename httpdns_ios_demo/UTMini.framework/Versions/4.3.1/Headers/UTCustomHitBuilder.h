//
//  UTCustomHitBuilder.h
//  miniUTInterface
//
//  Created by 宋军 on 14-10-17.
//  Copyright (c) 2014年 ___SONGJUN___. All rights reserved.
//

#import "UTHitBuilder.h"

@interface UTCustomHitBuilder : UTHitBuilder

-(void) setEventLabel:(NSString *) pEventId;

-(void) setEventPage:(NSString *) pPageName;

-(void) setDurationOnEvent:(long long) durationOnEvent;

@end
