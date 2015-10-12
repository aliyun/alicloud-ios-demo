//
//  ALBBMANEventCommitTool.h
//   
//
//  Created by 郭天 on 15/2/10.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBBMANEventCommitTool : NSObject

+ (void)commitEvent:(NSString *)eventId property:(NSMutableDictionary *)tempProperty;

@end
