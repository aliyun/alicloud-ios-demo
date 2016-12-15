//
//  oss_ios_demo.h
//  oss_ios_demo
//
//  Created by zhouzhuo on 9/16/15.
//  Copyright (c) 2015 zhouzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AliyunOSSDemo : NSObject

+ (instancetype)sharedInstance;

- (void)setupEnvironment;

- (void)runDemo;

- (void)uploadObjectAsync;

- (void)downloadObjectAsync;

- (void)resumableUpload;
@end
