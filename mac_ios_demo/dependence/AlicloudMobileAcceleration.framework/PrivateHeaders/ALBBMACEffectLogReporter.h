//
//  ALBBMACEffectLogReporter.h
//  ALBBMACSDK
//
//  Created by nanpo.yhl on 15/8/11.
//  Copyright (c) 2015年 com.taobao.com.cas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBBMACEffectLogReporter : NSObject

+(ALBBMACEffectLogReporter*)shareInstance;


/*
 * commit
 */
-(void)commitWithHost:(NSString*)host withRt:(int)rt;

@end
