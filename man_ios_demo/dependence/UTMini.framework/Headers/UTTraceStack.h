//
//  UTTraceStack.h
//  UTSDK
//
//  Created by Alvin on 14-8-6.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#ifndef UTSDK_UTTraceStack_h
#define UTSDK_UTTraceStack_h

@interface UTTraceStack : NSObject

@property(readwrite) int capacity;

+(UTTraceStack *) defaultInstance;

-(void) addTrace:(NSString *)aTraceContent;

-(NSArray *) getTraceStack;

@end


#endif
