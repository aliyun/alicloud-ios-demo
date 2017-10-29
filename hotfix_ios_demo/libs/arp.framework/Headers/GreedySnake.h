//
//  GreedySnake.h
//  owax
//
//  Created by junzhan on 2017/4/20.
//  Copyright © 2017年 taobao. All rights reserved.


#import <Foundation/Foundation.h>

@interface GreedySnake : NSObject

+ (void)cook:(NSString *)dish seasoning:(NSString *)seasoning;

+ (NSError *)eatNoodle:(NSString *)noodle rice:(NSString *)rice;

+ (NSError *)eatMeat:(NSString *)meat rice:(NSString *)rice;

+ (NSError *)eatPizza:(NSData *)pizza top:(NSString *)pizzaName rice:(NSString *)rice;

@end
