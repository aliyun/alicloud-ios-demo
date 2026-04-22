#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CrashHelper : NSObject

+ (void)triggerNSArrayException;
+ (void)triggerCppCrash;
+ (void)triggerMachException;
+ (void)triggerSignalCrash;

@end

NS_ASSUME_NONNULL_END
