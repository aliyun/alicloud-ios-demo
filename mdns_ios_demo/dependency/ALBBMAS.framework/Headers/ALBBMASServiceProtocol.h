//
//  ALBBMASServiceProtocol.h
//  TestMAS
//
//  Created by 郭天 on 15/3/12.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBBMASNetwork.h"
#import "ALBBMASCustomHitBuilder.h"
#import "ALBBMASAnalytics.h"
#import "ALBBMASBaseRequestAuthentication.h"
#import "ALBBMASPageHitBuilder.h"
#import "ALBBMASSecuritySDKRequestAuthentication.h"
#import "ALBBMASTracker.h"
#import "ALBBMASCustomPerformanceHitBuilder.h"

@protocol ALBBMASServiceProtocol <NSObject>

- (ALBBMASNetwork *)getMasNetwork;

- (ALBBMASAnalytics *)getMasAnalytics;

- (ALBBMASCustomHitBuilder *)getMasCustomHitBuilder;

- (ALBBMASPageHitBuilder *)getMasPageHitBuilder;

- (ALBBMASTracker *)getMasTracker;

- (ALBBMASCustomPerformanceHitBuilder *)getMasCustomPerformanceHitBuilder:(NSString *)performanceName;

@end
