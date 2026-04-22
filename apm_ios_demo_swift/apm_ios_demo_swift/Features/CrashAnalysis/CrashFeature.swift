import SwiftUI
import Darwin
import AlicloudApmCrashAnalysis

enum CrashTriggerType: CaseIterable, Hashable {
    case swiftRuntime
    case nsException
    case cpp
    case mach
    case swiftPreconditionFailure
    case signal
    case hang
    case watchdog
    case oom
    case backgroundCrash
    case deadlock
    case swiftArrayOutOfBounds
    case swiftFatalError
    case swiftUnownedReference
}

protocol CrashTriggering: AnyObject {
    func trigger(type: CrashTriggerType)
}

private enum SwiftCrashRuntime {
    private static var oomPointers: [UnsafeMutableRawPointer] = []
    private static let oomLock = NSLock()

    @inline(never)
    static func triggerRuntimeCrash() {
        let text: String? = nil
        _ = text!
    }

    static func triggerSignalCrash() {
        CrashHelper.triggerSignalCrash()
    }

    static func triggerHang() {
        DispatchQueue.main.async {
            Thread.sleep(forTimeInterval: 6.0)
        }
    }

    static func triggerOOM() {
        Self.oomLock.lock()
        Self.oomPointers.removeAll()
        Self.oomLock.unlock()

        DispatchQueue.global(qos: .default).async {
            let chunkSize: Int
#if targetEnvironment(simulator)
            chunkSize = 64 * 1024 * 1024
#else
            chunkSize = 16 * 1024 * 1024
#endif

            while true {
                autoreleasepool {
                    guard let chunk = malloc(chunkSize) else {
                        abort()
                    }

                    memset(chunk, 0xA5, chunkSize)
                    Self.oomLock.lock()
                    Self.oomPointers.append(chunk)
                    Self.oomLock.unlock()
                    usleep(20_000)
                }
            }
        }
    }

    static func triggerWatchdogKill() {
        DispatchQueue.main.async {
            Thread.sleep(forTimeInterval: 30.0)
        }
    }

    @inline(never)
    static func triggerBackgroundSwiftCrash() {
        DispatchQueue.global(qos: .default).async {
            fatalError("Trigger background Swift crash in demo page.")
        }
    }

    static func triggerDeadlock() {
        let serialQueue = DispatchQueue(label: "com.aliyun.emas.demo.deadlock")
        serialQueue.async {
            serialQueue.sync {
                print("Barrier task")
            }
        }
    }

    @inline(never)
    static func triggerArrayOutOfBoundsCrash() {
        let values = [1, 2, 3]
        _ = values[9]
    }

    @inline(never)
    static func triggerFatalErrorCrash() -> Never {
        fatalError("Trigger Swift fatalError in demo page.")
    }

    @inline(never)
    static func triggerPreconditionFailureCrash() -> Never {
        preconditionFailure("Trigger Swift preconditionFailure in demo page.")
    }

    @inline(never)
    static func triggerUnownedReferenceCrash() {
        final class Owner {}
        final class Holder {
            unowned let owner: Owner

            init(owner: Owner) {
                self.owner = owner
            }
        }

        let holder: Holder = {
            let owner = Owner()
            return Holder(owner: owner)
        }()
        _ = holder.owner
    }
}

final class CrashBridge: CrashTriggering {
    func trigger(type: CrashTriggerType) {
        switch type {
        case .swiftRuntime:
            SwiftCrashRuntime.triggerRuntimeCrash()
        case .nsException:
            CrashHelper.triggerNSArrayException()
        case .cpp:
            CrashHelper.triggerCppCrash()
        case .mach:
            CrashHelper.triggerMachException()
        case .swiftPreconditionFailure:
            SwiftCrashRuntime.triggerPreconditionFailureCrash()
        case .signal:
            SwiftCrashRuntime.triggerSignalCrash()
        case .hang:
            SwiftCrashRuntime.triggerHang()
        case .watchdog:
            SwiftCrashRuntime.triggerWatchdogKill()
        case .oom:
            SwiftCrashRuntime.triggerOOM()
        case .backgroundCrash:
            SwiftCrashRuntime.triggerBackgroundSwiftCrash()
        case .deadlock:
            SwiftCrashRuntime.triggerDeadlock()
        case .swiftArrayOutOfBounds:
            SwiftCrashRuntime.triggerArrayOutOfBoundsCrash()
        case .swiftFatalError:
            SwiftCrashRuntime.triggerFatalErrorCrash()
        case .swiftUnownedReference:
            SwiftCrashRuntime.triggerUnownedReferenceCrash()
        }
    }
}

@MainActor
final class CrashFeatureViewModel: ObservableObject {
    private let overlayCoordinator: OverlayCoordinator
    private let toastCenter: ToastCenter
    private let crashTrigger: CrashTriggering
    private let recordCustomError: (_ error: NSError, _ metadata: [String: String]) -> Void

    init(
        overlayCoordinator: OverlayCoordinator,
        toastCenter: ToastCenter,
        crashTrigger: CrashTriggering,
        recordCustomError: @escaping (_ error: NSError, _ metadata: [String: String]) -> Void = { error, metadata in
            let crashAnalysis = CrashAnalysis.crashAnalysis()
            metadata.forEach { key, value in
                crashAnalysis.setCustomValue(value, forKey: key)
            }
            crashAnalysis.record(error: error, userInfo: metadata)
        }
    ) {
        self.overlayCoordinator = overlayCoordinator
        self.toastCenter = toastCenter
        self.crashTrigger = crashTrigger
        self.recordCustomError = recordCustomError
    }

    func triggerCrash() {
        overlayCoordinator.presentConfirmation(
            title: "崩溃",
            message: "即将触发崩溃，App 将闪退，稍后可在 EMAS 控制台看到崩溃信息。"
        ) { [crashTrigger] in
            crashTrigger.trigger(type: .swiftRuntime)
        }
    }

    func triggerHang() {
        overlayCoordinator.presentConfirmation(
            title: "卡顿",
            message: "即将触发应用「卡顿」。卡顿结束后，请切换至后台触发上报，稍后可在 EMAS 控制台看到卡顿信息。"
        ) { [crashTrigger, toastCenter] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                toastCenter.show(message: "卡顿结束")
            }
            crashTrigger.trigger(type: .hang)
        }
    }

    func recordCustomExceptions() {
        for index in 0..<8 {
            let metadata = [
                "configCustomInfoWithKey": "customValue-\(index + 1)",
                "errorInfoKey": "errorInfoValue-\(index + 1)",
                "errorScene": "home_custom_exception",
            ]
            let error = NSError(
                domain: "customError",
                code: 10001 + index,
                userInfo: metadata
            )
            recordCustomError(error, metadata)
        }

        overlayCoordinator.presentInfoAlert(
            title: "自定义异常",
            message: "已触发多条自定义异常，请在 EMAS 控制台查看自定义异常详情。"
        )
    }
}

struct OtherCrashTypeItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let type: CrashTriggerType
}

@MainActor
final class OtherCrashTypesViewModel: ObservableObject {
    private let overlayCoordinator: OverlayCoordinator
    private let crashTrigger: CrashTriggering

    let items: [OtherCrashTypeItem] = [
        OtherCrashTypeItem(title: "NSException", type: .nsException),
        OtherCrashTypeItem(title: "C++ 异常", type: .cpp),
        OtherCrashTypeItem(title: "Mach 异常", type: .mach),
        OtherCrashTypeItem(title: "SIGNAL 崩溃", type: .signal),
        OtherCrashTypeItem(title: "卡死", type: .watchdog),
        OtherCrashTypeItem(title: "OOM", type: .oom),
        OtherCrashTypeItem(title: "Background Crash", type: .backgroundCrash),
        OtherCrashTypeItem(title: "Deadlock", type: .deadlock),
        OtherCrashTypeItem(title: "数组越界", type: .swiftArrayOutOfBounds),
        OtherCrashTypeItem(title: "fatalError", type: .swiftFatalError),
        OtherCrashTypeItem(title: "Unowned 引用崩溃", type: .swiftUnownedReference),
        OtherCrashTypeItem(title: "preconditionFailure", type: .swiftPreconditionFailure),
    ]

    init(overlayCoordinator: OverlayCoordinator, crashTrigger: CrashTriggering) {
        self.overlayCoordinator = overlayCoordinator
        self.crashTrigger = crashTrigger
    }

    func trigger(_ item: OtherCrashTypeItem) {
        let message: String
        switch item.type {
        case .watchdog:
            message = "即将触发「卡死」，主线程会阻塞 30 秒，等待系统终止应用。终止后可在 EMAS 控制台查看对应数据。"
        case .oom:
            message = "即将触发「OOM」，App 将闪退，重启应用后可在 EMAS 控制台看到崩溃信息。"
        case .mach:
            message = "即将触发「\(item.title)」，将使用底层 trap 触发崩溃，App 将闪退。"
        default:
            message = "即将触发「\(item.title)」，App 将闪退，稍后可在 EMAS 控制台看到崩溃信息。"
        }

        overlayCoordinator.presentConfirmation(
            title: item.title,
            message: message
        ) { [crashTrigger] in
            crashTrigger.trigger(type: item.type)
        }
    }
}

struct OtherCrashTypesScreen: View {
    @ObservedObject var viewModel: OtherCrashTypesViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
    ]

    var body: some View {
        SecondaryPageLayout(title: "其它类型崩溃") {
            VStack(alignment: .leading, spacing: DemoSpacing.sectionTop) {
                TipCardView(text: "更多崩溃和错误类型，点击按钮触发对应类型的异常。触发后请前往 EMAS 控制台查看崩溃详情和堆栈信息。")

                SectionTitleView(title: "崩溃列表")

                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(viewModel.items) { item in
                        Button {
                            viewModel.trigger(item)
                        } label: {
                            DemoSecondaryActionButton(title: item.title)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("crash.catalog.\(item.title)")
                    }
                }
            }
            .padding(.horizontal, DemoSpacing.horizontal)
        }
    }
}
