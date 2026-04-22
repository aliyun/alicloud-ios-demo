import SwiftUI

@MainActor
final class MemoryFeatureViewModel: ObservableObject {
    private let overlayCoordinator: OverlayCoordinator
    private let crashTrigger: CrashTriggering
    private let leakScenario: any LeakScenarioSimulating
    private let largeObjectScenario: any LargeObjectScenarioSimulating

    init(
        overlayCoordinator: OverlayCoordinator,
        crashTrigger: CrashTriggering,
        leakScenario: any LeakScenarioSimulating,
        largeObjectScenario: any LargeObjectScenarioSimulating
    ) {
        self.overlayCoordinator = overlayCoordinator
        self.crashTrigger = crashTrigger
        self.leakScenario = leakScenario
        self.largeObjectScenario = largeObjectScenario
    }

    func triggerOOM() {
        overlayCoordinator.presentConfirmation(
            title: "OOM",
            message: "即将触发「OOM」，App 将闪退，重启应用之后可在 EMAS 控制台看到崩溃信息。"
        ) { [crashTrigger] in
            crashTrigger.trigger(type: .oom)
        }
    }

    func triggerMemoryLeak() {
        leakScenario.createScenario()
        overlayCoordinator.presentInfoAlert(
            title: "内存泄漏",
            message: "已构造「内存泄漏」场景。请连续两次将应用切换至后台：首次触发内存检测，第二次触发结果上报。相关结果可稍后在 EMAS 控制台查看。"
        )
    }

    func triggerLargeObject() {
        let success = largeObjectScenario.triggerScenario()
        overlayCoordinator.presentInfoAlert(
            title: "大对象",
            message: success
                ? "已触发「大对象」分配场景。请切换至后台触发上报，稍后可在 EMAS 控制台查看。"
                : "触发失败，请稍后重试。"
        )
    }
}
