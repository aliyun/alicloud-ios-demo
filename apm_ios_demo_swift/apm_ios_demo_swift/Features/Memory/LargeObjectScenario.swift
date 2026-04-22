import Foundation

protocol LargeObjectScenarioSimulating: AnyObject {
    @discardableResult func triggerScenario() -> Bool
}

final class LargeObjectScenario: LargeObjectScenarioSimulating {
    private let allocator: any LargeObjectMemoryAllocating
    private let delayedVMLargeObjectAllocator: (@escaping () -> Void) -> Void

    init(
        allocator: any LargeObjectMemoryAllocating = SystemLargeObjectAllocator(),
        delayedVMLargeObjectAllocator: @escaping (@escaping () -> Void) -> Void = { work in
            DispatchQueue.main.asyncAfter(
                deadline: .now() + LargeObjectScenarioConstants.vmAllocateDelaySeconds,
                execute: work
            )
        }
    ) {
        self.allocator = allocator
        self.delayedVMLargeObjectAllocator = delayedVMLargeObjectAllocator
    }

    @discardableResult
    func triggerScenario() -> Bool {
        guard warmupMemoryUsageToThreshold() else {
            return false
        }

        delayedVMLargeObjectAllocator { [weak self] in
            self?.allocateVMLargeObject()
        }

        return true
    }

    private func warmupMemoryUsageToThreshold() -> Bool {
        var currentRatio = allocator.currentMemoryUsageRatio()
        if currentRatio >= LargeObjectScenarioConstants.targetUsageRatio {
            return true
        }

        for _ in 0..<LargeObjectScenarioConstants.maxMallocIterations {
            guard allocator.allocateWarmupChunk(bytes: LargeObjectScenarioConstants.mallocChunkSize) else {
                return false
            }

            currentRatio = allocator.currentMemoryUsageRatio()
            if currentRatio >= LargeObjectScenarioConstants.targetUsageRatio {
                return true
            }
        }

        print("large object warmup reached max iterations without hitting target ratio, current ratio: \(currentRatio)")
        return false
    }

    private func allocateVMLargeObject() {
        _ = allocator.allocateVMLargeObject(bytes: LargeObjectScenarioConstants.vmAllocateSize)
    }
}
