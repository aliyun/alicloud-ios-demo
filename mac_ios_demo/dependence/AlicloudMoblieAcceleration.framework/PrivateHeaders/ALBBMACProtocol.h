//
//  ALBBMACProtocol.h
//  ALBBMACSDK
//
//  Created by nanpo.yhl on 15/7/7.
//  Copyright (c) 2015年 com.taobao.com.cas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBBMACProtocol : NSURLProtocol

@property(nonatomic,strong)NSThread* from;

/*
 * 重试http的情况下调用
 */
-(void)buildHTTPRequest;
@end
