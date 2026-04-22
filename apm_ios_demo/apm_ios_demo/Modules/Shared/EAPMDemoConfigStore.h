#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EAPMDemoConfigStore : NSObject

+ (void)userDefaultSetObject:(id)value forKey:(NSString *)key;
+ (id)userDefaultGet:(NSString *)key;
+ (nullable NSString *)storedUserId;
+ (nullable NSString *)storedUserNick;
+ (void)saveUserId:(nullable NSString *)userId userNick:(nullable NSString *)userNick;

@end

NS_ASSUME_NONNULL_END
