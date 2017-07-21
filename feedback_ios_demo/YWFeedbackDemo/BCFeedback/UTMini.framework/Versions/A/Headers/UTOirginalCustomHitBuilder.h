//
//  UTOirginalCustomHitBuilder.h
//  miniUTInterface
//
//  Created by 宋军 on 14/10/28.
//  Copyright (c) 2014年 ___SONGJUN___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTHitBuilder.h"
@interface UTOirginalCustomHitBuilder : UTHitBuilder

-(void) setPageName:(NSString *) pPage;

-(void) setEventId:(NSString *) pEventId;

-(void) setArg1:(NSString *) pArg1;

-(void) setArg2:(NSString *) pArg2;

-(void) setArg3:(NSString *) pArg3;

-(void) setArgs:(NSDictionary *) pArgs;

@end
