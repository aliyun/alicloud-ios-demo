//
//  HTTPDNSTools.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTTPDNSTools : NSObject

+ (BOOL)isValidString:(id)obj;

+ (id)storyBoardInstantiateViewController:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
