#import "CrashHelper.h"
#import "CrashHandler.hpp"
#import <signal.h>

@implementation CrashHelper

+ (void)triggerNSArrayException {
    NSArray *array = @[];
    NSLog(@"Crash element: %@", array[1]);
}

+ (void)triggerCppCrash {
    triggerCppCrash();
}

+ (void)triggerMachException {
    __builtin_trap();
}

+ (void)triggerSignalCrash {
    raise(SIGSEGV);
    signal(SIGSEGV, SIG_DFL);
    raise(SIGSEGV);
}

@end
