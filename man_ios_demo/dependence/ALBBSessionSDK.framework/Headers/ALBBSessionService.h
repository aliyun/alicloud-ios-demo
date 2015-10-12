//
//  ALBBSessionService.h
//  ALBBOneSDK
//
//  Created by wuxiang on 15/4/1.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALBB_SESSION_SDK_VERSION  @"1.0.1"

typedef void (^initSessionSuccessCallback)();
typedef void (^initSessionFailCallback)(NSError *error);

typedef void (^CompletionBlock)(BOOL success);

@interface ALBBSessionService : NSObject

+(ALBBSessionService *) sharedInstance;

- (void) initSession:(initSessionSuccessCallback) successCallback
     failureCallback:(initSessionSuccessCallback) failedCallback;


- (NSString *) refleshSession;

- (NSString *) getSessionId;


- (NSString *) getSessionId:(NSString *) appkey
                      error:(NSError **) error;

@end
