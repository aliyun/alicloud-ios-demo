#import "CrashHelper.h"

@implementation CrashHelper

+ (void)triggerCrash {
    // 触发EXC_BAD_ACCESS崩溃
    NSArray *array = @[];
    NSLog(@"Crash element: %@", array[1]);
}

@end
