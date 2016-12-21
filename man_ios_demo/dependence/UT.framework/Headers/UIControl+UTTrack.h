//
//  UTUIControlTrack.h
//  UTSDK
//
//  Created by zifeng on 14-4-11.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIControl(UTTrackHook)

@property(nonatomic, retain) NSString *utActionName;
@property(nonatomic, retain) NSDictionary *utArgs;

@end
