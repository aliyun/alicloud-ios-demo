//
//  ALBBMASTracker.h
//  TestMAS
//
//  Created by 郭天 on 15/3/5.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UTMini/UTTracker.h>
//#import "UTTracker.h"

@interface ALBBMASTracker : UTTracker

-(id) initWithTrackId:(NSString *) pTrackId;

-(void) setGlobalProperty:(NSString *) pKey value:(NSString *) pValue;

-(void) removeGlobalProperty:(NSString *) pKey;

-(NSString *) getGlobalProperty:(NSString *) pKey;

-(void) send:(NSDictionary *) pLogDict;

-(void) pageAppear:(UIViewController *) pViewController;

-(void) pageDisAppear:(UIViewController *) pViewController;

-(void) updatePageProperties:(UIViewController *) pViewController properties:(NSDictionary *) pProperties;

@end
