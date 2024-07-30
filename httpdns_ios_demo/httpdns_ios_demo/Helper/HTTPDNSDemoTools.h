//
//  HTTPDNSDemoTools.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTTPDNSDemoTools : NSObject

+ (BOOL)isValidString:(id)obj;

+ (id)storyBoardInstantiateViewController:(NSString *)identifier;

+ (void)userDefaultSetObject:(id)value forKey:(NSString *)key;

+ (void)userDefaultSetBool:(BOOL)value forKey:(NSString *)key;

+ (id)userDefaultGet:(NSString *)key;

+ (BOOL)userDefaultBool:(NSString *)key;

+ (void)userDefaultRemove:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
