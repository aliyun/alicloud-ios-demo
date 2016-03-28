//
//  ALBBMANTracker.h
//   
//
//  Created by 郭天 on 15/3/5.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UTMini/UTTracker.h>

@interface ALBBMANTracker : UTTracker

-(id) initWithTrackId:(NSString *) pTrackId;

-(void) setGlobalProperty:(NSString *) pKey value:(NSString *) pValue;

-(void) removeGlobalProperty:(NSString *) pKey;

-(NSString *) getGlobalProperty:(NSString *) pKey;

-(void) send:(NSDictionary *) pLogDict;

@end
