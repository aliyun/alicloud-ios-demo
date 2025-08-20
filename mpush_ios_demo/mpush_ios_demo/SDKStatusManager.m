//
//  SDKStatusManager.m
//  mpush_ios_demo
//
//  Created by Miracle on 2025/8/1.
//  Copyright © 2025 alibaba. All rights reserved.
//

#import "SDKStatusManager.h"

static BOOL _SDKInitIsSuccess = NO;

@implementation SDKStatusManager

+ (BOOL)getSDKInitStatus {
    return _SDKInitIsSuccess;
}

+ (void)updateSDKStatus:(BOOL)isSuccess {
    _SDKInitIsSuccess = isSuccess;
}

@end
