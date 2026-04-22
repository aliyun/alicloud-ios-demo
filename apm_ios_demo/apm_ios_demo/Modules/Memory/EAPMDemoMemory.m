#import "EAPMDemoMemory.h"

#import "EAPMDemoCrashViewController.h"
#import "EAPMDemoHomeUI.h"
#import "../Shared/EAPMDemoOverlayPresenter.h"
#import <mach/mach.h>
#import <TargetConditionals.h>
#import <stdlib.h>
#import <string.h>

static const float EAPMDemoLargeObjectTargetUsageRatio = 0.10f;
static const size_t EAPMDemoLargeObjectMallocChunkSize = 8 * 1024 * 1024;
static const size_t EAPMDemoLargeObjectVMAllocateSize = 10 * 1024 * 1024;
static const NSUInteger EAPMDemoLargeObjectMaxMallocIterations = 128;
static const NSTimeInterval EAPMDemoLargeObjectVMAllocateDelaySeconds = 1.0;
static const uint64_t EAPMDemoLargeObjectSimulatorMemoryLimit = 3000000000ull;

@interface EAPMDemoMemoryLeakViewController : UIViewController

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong, nullable) UIViewController *pageANamePath;
@property (nonatomic, strong, nullable) UIViewController *pageBNamePath;
@property (nonatomic, strong, nullable) UIViewController *pageCNamePath;

@end

@implementation EAPMDemoMemoryLeakViewController

- (void)dealloc {
    NSLog(@"EAPMDemoMemoryLeakViewController %@ dealloc", self.name);
}

@end

static NSArray<EAPMDemoMemoryLeakViewController *> *EAPMDemoMemoryLeakViewControllers = nil;

static NSMutableArray<NSValue *> *EAPMDemoLargeObjectMallocPointers(void) {
    static NSMutableArray<NSValue *> *pointers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pointers = [NSMutableArray array];
    });
    return pointers;
}

static NSMutableArray<NSValue *> *EAPMDemoLargeObjectVMAllocations(void) {
    static NSMutableArray<NSValue *> *addresses = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        addresses = [NSMutableArray array];
    });
    return addresses;
}

static float EAPMDemoCurrentMemoryUsageRatio(void) {
    task_vm_info_data_t info = {};
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t err = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&info, &count);
    if (err != KERN_SUCCESS) {
        NSLog(@"task_info failed when calculating memory usage ratio: %d", err);
        return 0.0f;
    }

#if TARGET_OS_SIMULATOR
    uint64_t remaining = EAPMDemoLargeObjectSimulatorMemoryLimit < info.phys_footprint
        ? 0
        : EAPMDemoLargeObjectSimulatorMemoryLimit - info.phys_footprint;
#else
    uint64_t remaining = info.limit_bytes_remaining;
#endif

    uint64_t total = info.phys_footprint + remaining;
    if (total == 0) {
        return 0.0f;
    }

    return (float)info.phys_footprint / (float)total;
}

static BOOL EAPMDemoWarmupMemoryUsageToThreshold(void) {
    float currentRatio = EAPMDemoCurrentMemoryUsageRatio();
    if (currentRatio >= EAPMDemoLargeObjectTargetUsageRatio) {
        return YES;
    }

    NSMutableArray<NSValue *> *mallocPointers = EAPMDemoLargeObjectMallocPointers();
    for (NSUInteger iteration = 0; iteration < EAPMDemoLargeObjectMaxMallocIterations; iteration++) {
        void *ptr = malloc(EAPMDemoLargeObjectMallocChunkSize);
        if (!ptr) {
            NSLog(@"malloc failed during large object warmup");
            return NO;
        }

        memset(ptr, 1, EAPMDemoLargeObjectMallocChunkSize);
        [mallocPointers addObject:[NSValue valueWithPointer:ptr]];

        currentRatio = EAPMDemoCurrentMemoryUsageRatio();
        if (currentRatio >= EAPMDemoLargeObjectTargetUsageRatio) {
            return YES;
        }
    }

    NSLog(@"large object warmup reached max iterations without hitting target ratio, current ratio: %.4f", currentRatio);
    return NO;
}

static BOOL EAPMDemoAllocateLargeObjectMemory(void) {
    vm_address_t address = 0;
    kern_return_t ret = vm_allocate((vm_map_t)mach_task_self(), &address, EAPMDemoLargeObjectVMAllocateSize, VM_FLAGS_ANYWHERE);
    if (ret != KERN_SUCCESS) {
        NSLog(@"vm_allocate failed: %d", ret);
        return NO;
    }

    [EAPMDemoLargeObjectVMAllocations() addObject:[NSValue valueWithPointer:(void *)address]];
    return YES;
}

static void EAPMDemoTriggerABCCycleLeak(void) {
    if (EAPMDemoMemoryLeakViewControllers.count == 3) {
        return;
    }

    EAPMDemoMemoryLeakViewController *viewControllerA = [[EAPMDemoMemoryLeakViewController alloc] init];
    viewControllerA.name = @"A";

    EAPMDemoMemoryLeakViewController *viewControllerB = [[EAPMDemoMemoryLeakViewController alloc] init];
    viewControllerB.name = @"B";

    EAPMDemoMemoryLeakViewController *viewControllerC = [[EAPMDemoMemoryLeakViewController alloc] init];
    viewControllerC.name = @"C";

    viewControllerA.pageBNamePath = viewControllerB;
    viewControllerB.pageCNamePath = viewControllerC;
    viewControllerC.pageANamePath = viewControllerA;

    EAPMDemoMemoryLeakViewControllers = @[viewControllerA, viewControllerB, viewControllerC];

    NSLog(@"已创建 UIViewController ABC 循环引用: A(%p) <-> B(%p) <-> C(%p)",
          viewControllerA,
          viewControllerB,
          viewControllerC);
}

static void EAPMDemoPresentMemoryLeakAlert(UIViewController *presenter) {
    if (!presenter || presenter.presentedViewController) {
        return;
    }

    EAPMDemoTriggerABCCycleLeak();

    [EAPMDemoAlertPresenter presentAlertFrom:presenter
                                       title:@"内存泄漏"
                                     message:@"已构造「内存泄漏」场景。请连续两次将应用切换至后台：首次触发内存检测，第二次触发结果上报。相关结果可稍后在 EMAS 控制台查看。"
                                     actions:@[
        [EAPMDemoAlertAction actionWithTitle:@"知道了"
                                       style:EAPMDemoAlertActionStylePrimary
                                         handler:nil],
    ]];
}

static void EAPMDemoPresentLargeObjectAlert(UIViewController *presenter, BOOL success) {
    if (!presenter || presenter.presentedViewController) {
        return;
    }

    NSString *message = success
        ? @"已触发「大对象」分配场景。请切换至后台触发上报，稍后可在 EMAS 控制台查看。"
        : @"触发失败，请稍后重试。";
    [EAPMDemoAlertPresenter presentAlertFrom:presenter
                                       title:@"大对象"
                                     message:message
                                     actions:@[
        [EAPMDemoAlertAction actionWithTitle:@"知道了"
                                       style:EAPMDemoAlertActionStylePrimary
                                         handler:nil],
    ]];
}

static void EAPMDemoHandleLargeObjectAction(UIViewController *presenter) {
    if (!presenter || presenter.presentedViewController) {
        return;
    }

    if (!EAPMDemoWarmupMemoryUsageToThreshold()) {
        EAPMDemoPresentLargeObjectAlert(presenter, NO);
        return;
    }

    EAPMDemoPresentLargeObjectAlert(presenter, YES);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(EAPMDemoLargeObjectVMAllocateDelaySeconds * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        EAPMDemoAllocateLargeObjectMemory();
    });
}

@implementation EAPMDemoMemory

+ (EAPMDemoHomeSectionModel *)sectionWithPresenter:(UIViewController *)presenter {
    __weak UIViewController *weakPresenter = presenter;
    return [EAPMDemoHomeSectionModel sectionWithTitle:@"内存分析" items:@[
        [EAPMDemoHomeActionItem itemWithTitle:@"OOM" actionHandler:^{
            [EAPMDemoCrashViewController presentOOMAlertFromViewController:weakPresenter];
        }],
        [EAPMDemoHomeActionItem itemWithTitle:@"内存泄漏" actionHandler:^{
            EAPMDemoPresentMemoryLeakAlert(weakPresenter);
        }],
        [EAPMDemoHomeActionItem itemWithTitle:@"大对象" actionHandler:^{
            EAPMDemoHandleLargeObjectAction(weakPresenter);
        }],
    ]];
}

@end
