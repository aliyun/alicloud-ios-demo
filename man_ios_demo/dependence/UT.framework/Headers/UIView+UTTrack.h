//
//  UIView+UTTrack.h
//  UTSDK
//
//  Created by Alvin on 14-5-15.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#ifndef UTSDK_UIView_UTTrack_h
#define UTSDK_UIView_UTTrack_h
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView(UTTrackHook)

@property(nonatomic, retain) NSString *utActionName;
@property(nonatomic, retain) NSDictionary *utArgs;
@property(nonatomic, retain) NSURL *utNavUrl;
@property(nonatomic, retain) NSString * utPageNameAlias;// 页面别名

@end


#endif
