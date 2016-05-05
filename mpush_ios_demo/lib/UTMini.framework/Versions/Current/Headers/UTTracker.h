//
//  UTTracker.h
//  miniUTInterface
//
//  Created by 宋军 on 14-10-14.
//  Copyright (c) 2014年 ___SONGJUN___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIWebView.h>

@interface UTTracker : NSObject

-(id) initWithTrackId:(NSString *) pTrackId;

-(void) setGlobalProperty:(NSString *) pKey value:(NSString *) pValue;

-(void) removeGlobalProperty:(NSString *) pKey;

-(NSString *) getGlobalProperty:(NSString *) pKey;

-(void) send:(NSDictionary *) pLogDict;

-(void) pageAppear:(UIViewController *) pViewController;

-(void) pageDisAppear:(UIViewController *) pViewController;

-(void) updatePageProperties:(UIViewController *) pViewController properties:(NSDictionary *) pProperties;

@end
