import Foundation
import Darwin

enum LargeObjectScenarioConstants {
    static let targetUsageRatio: Float = 0.10
    static let mallocChunkSize = 8 * 1024 * 1024
    static let vmAllocateSize = 10 * 1024 * 1024
    static let maxMallocIterations = 128
    static let vmAllocateDelaySeconds = 1.0
    static let simulatorMemoryLimit: UInt64 = 3_000_000_000
}

protocol LargeObjectMemoryAllocating: AnyObject {
    func currentMemoryUsageRatio() -> Float
    func allocateWarmupChunk(bytes: Int) -> Bool
    func allocateVMLargeObject(bytes: Int) -> Bool
}

final class SystemLargeObjectAllocator: LargeObjectMemoryAllocating {
    private var mallocPointers: [UnsafeMutableRawPointer] = []
    private var vmAllocations: [vm_address_t] = []

    func currentMemoryUsageRatio() -> Float {
        var info = task_vm_info_data_t()
        var count = mach_msg_type_number_t(
            MemoryLayout.size(ofValue: info) / MemoryLayout<natural_t>.size
        )

        let result: kern_return_t = withUnsafeMutablePointer(to: &info) { pointer in
            pointer.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { reboundPointer in
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), reboundPointer, &count)
            }
        }

        guard result == KERN_SUCCESS else {
            print("task_info failed when calculating memory usage ratio: \(result)")
            return 0
        }

#if targetEnvironment(simulator)
        let remaining = LargeObjectScenarioConstants.simulatorMemoryLimit < info.phys_footprint
            ? 0
            : LargeObjectScenarioConstants.simulatorMemoryLimit - info.phys_footprint
#else
        let remaining = info.limit_bytes_remaining
#endif

        let total = info.phys_footprint + remaining
        guard total > 0 else {
            return 0
        }

        return Float(info.phys_footprint) / Float(total)
    }

    func allocateWarmupChunk(bytes: Int) -> Bool {
        guard let pointer = malloc(bytes) else {
            print("malloc failed during large object warmup")
            return false
        }

        memset(pointer, 1, bytes)
        mallocPointers.append(pointer)
        return true
    }

    func allocateVMLargeObject(bytes: Int) -> Bool {
        var address: vm_address_t = 0
        let result = vm_allocate(mach_task_self_, &address, vm_size_t(bytes), VM_FLAGS_ANYWHERE)
        guard result == KERN_SUCCESS else {
            print("vm_allocate failed: \(result)")
            return false
        }

        vmAllocations.append(address)
        return true
    }
}
