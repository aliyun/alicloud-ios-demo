//
//  UTMapBuilder.h
//  miniUTInterface
//
//  Created by 宋军 on 14-10-14.
//  Copyright (c) 2014年 ___SONGJUN___. All rights reserved.
//

#import "UTHitBuilder.h"

@interface UTPageHitBuilder : UTHitBuilder

-(void) setPageName:(NSString *) pPageName;

-(void) setReferPage:(NSString *) pReferPageName;

-(void) setDurationOnPage:(long long ) durationTimeOnPage;

@end
