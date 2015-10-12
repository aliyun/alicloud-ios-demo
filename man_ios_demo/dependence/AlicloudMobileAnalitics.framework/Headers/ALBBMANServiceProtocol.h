//
//  ALBBMANServiceProtocol.h
//   
//
//  Created by 郭天 on 15/3/12.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBBMANCustomHitBuilder.h"
#import "ALBBMANAnalytics.h"
#import "ALBBMANPageHitBuilder.h"
#import "ALBBMANTracker.h"
#import "ALBBMANCustomPerformanceHitBuilder.h"

@protocol ALBBMANServiceProtocol <NSObject>

- (ALBBMANAnalytics *)getMANAnalytics;

- (ALBBMANCustomHitBuilder *)getMANCustomHitBuilder;

- (ALBBMANPageHitBuilder *)getMANPageHitBuilder;

- (ALBBMANTracker *)getManTracker;

- (ALBBMANCustomPerformanceHitBuilder *)getManCustomPerformanceHitBuilder:(NSString *)performanceName;

@end
