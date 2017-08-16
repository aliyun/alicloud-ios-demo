//
//  ALBBMANPageHitBuilder.h
//   
//
//  Created by 郭天 on 15/3/5.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UTMini/UTPageHitBuilder.h>

@interface ALBBMANPageHitBuilder : UTPageHitBuilder

-(void) setProperty:(NSString *) pKey value:(NSString *) pValue;

-(void) setProperties:(NSDictionary *) pPageProperties;

-(void) setPageName:(NSString *) pPageName;

-(void) setReferPage:(NSString *) pReferPageName;

-(void) setDurationOnPage:(long long ) durationTimeOnPage;

@end
