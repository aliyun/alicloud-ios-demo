//
//  UTBaseMapBuilder.h
//  miniUTInterface
//
//  Created by 宋军 on 14-10-14.
//  Copyright (c) 2014年 ___SONGJUN___. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UTHitBuilder : NSObject


-(NSDictionary *) build;

-(void) setProperty:(NSString *) pKey value:(NSString *) pValue;

-(void) setProperties:(NSDictionary *) pPageProperties;

@end
