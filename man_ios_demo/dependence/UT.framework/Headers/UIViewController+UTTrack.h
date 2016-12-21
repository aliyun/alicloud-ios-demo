//
//  UTUIViewControllerTrack.h
//  UTSDK
//
//  Created by zifeng on 14-4-10.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewController(UTTrackHook)

@property(nonatomic, retain) NSString *utActionName;
@property(nonatomic, retain) NSDictionary *utArgs;
@property(nonatomic, retain) NSURL *utNavUrl;
@property(nonatomic, retain) NSDictionary *utProperties;
@property(nonatomic, retain) NSString * utPageNameAlias;// 页面别名
@property(nonatomic,retain) NSString * utH5HasCalled;
@property(nonatomic,retain) NSString * utHasAppeared;

@end
