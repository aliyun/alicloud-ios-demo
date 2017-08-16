//
//  ALBBMANIRequestAuthentication.h
//   
//
//  Created by 郭天 on 15/3/5.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UTMini/UTIRequestAuthentication.h>

@protocol ALBBMANIRequestAuthentication <UTIRequestAuthentication>

-(NSString *) getAppKey;

-(NSString *) getSign:(NSString*) pToBeSignStr;

@end


