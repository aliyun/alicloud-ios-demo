//
//  UTHybridHelper.h
//  miniUTSDK
//
//  Created by 宋军 on 14/11/26.
//  Copyright (c) 2014年 ___SONGJUN___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIWebView.h>
@interface UTHybridHelper : NSObject

+(UTHybridHelper *) getInstance;

-(void) h5UT:(NSDictionary *) dataDict view:(UIWebView *) view;

-(void) setH5Url:(NSString *) url;

@end
