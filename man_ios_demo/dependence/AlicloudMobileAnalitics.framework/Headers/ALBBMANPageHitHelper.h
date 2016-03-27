//
//  ALBBMANPageHitHelper.h
//  AlicloudMobileAnalitics
//
//  Created by lingkun on 16/3/23.
//  Copyright © 2016年 com.aliyun.tds. All rights reserved.
//

#ifndef ALBBMANPageHitHelper_h
#define ALBBMANPageHitHelper_h
#import <Foundation/Foundation.h>
#import <UTMini/UTTracker.h>

@interface ALBBMANPageHitHelper : NSObject

+ (instancetype)getInstance;

-(void) pageAppear:(UIViewController *) pViewController;

-(void) pageDisAppear:(UIViewController *) pViewController;

-(void) updatePageProperties:(UIViewController *) pViewController properties:(NSDictionary *) pProperties;

@end

#endif /* ALBBMANPageHitHelper_h */
