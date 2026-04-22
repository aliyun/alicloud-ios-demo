import Foundation

enum DemoFatalLaunchError: Identifiable, Equatable {
    case missingConfiguration

    var id: String {
        switch self {
        case .missingConfiguration:
            return "missingConfiguration"
        }
    }

    var title: String {
        switch self {
        case .missingConfiguration:
            return "应用配置缺失"
        }
    }

    var message: String {
        switch self {
        case .missingConfiguration:
            return "当前缺少 appKey 等应用配置。\n请前往 EMAS 控制台获取应用配置，并修改 AppDelegate 中的 APM 配置信息后重新启动应用。"
        }
    }
}

@MainActor
final class AppEnvironment: ObservableObject {
    static let shared = AppEnvironment()

    let overlayCoordinator: OverlayCoordinator
    let toastCenter: ToastCenter
    let settingsStore: SettingsStoreProtocol
    let leakScenario: any LeakScenarioSimulating
    let largeObjectScenario: any LargeObjectScenarioSimulating
    let crashTrigger: CrashTriggering

    let homeViewModel: HomeViewModel
    let settingsViewModel: SettingsViewModel
    let crashViewModel: CrashFeatureViewModel
    let otherCrashTypesViewModel: OtherCrashTypesViewModel
    let performanceViewModel: PerformanceFeatureViewModel
    let networkAnalysisViewModel: NetworkAnalysisViewModel
    let memoryViewModel: MemoryFeatureViewModel
    let remoteLogViewModel: RemoteLogFeatureViewModel

    @Published var fatalLaunchError: DemoFatalLaunchError?

    init(
        overlayCoordinator: OverlayCoordinator = OverlayCoordinator(),
        toastCenter: ToastCenter = ToastCenter(),
        settingsStore: SettingsStoreProtocol = SettingsStore(),
        leakScenario: any LeakScenarioSimulating = ViewControllerLeakScenario(),
        largeObjectScenario: any LargeObjectScenarioSimulating = LargeObjectScenario(),
        crashTrigger: CrashTriggering = CrashBridge()
    ) {
        self.overlayCoordinator = overlayCoordinator
        self.toastCenter = toastCenter
        self.settingsStore = settingsStore
        self.leakScenario = leakScenario
        self.largeObjectScenario = largeObjectScenario
        self.crashTrigger = crashTrigger

        let networkClient = URLSessionNetworkClient()
        homeViewModel = HomeViewModel()
        settingsViewModel = SettingsViewModel(
            settingsStore: settingsStore,
            toastCenter: toastCenter
        )
        crashViewModel = CrashFeatureViewModel(
            overlayCoordinator: overlayCoordinator,
            toastCenter: toastCenter,
            crashTrigger: crashTrigger
        )
        otherCrashTypesViewModel = OtherCrashTypesViewModel(
            overlayCoordinator: overlayCoordinator,
            crashTrigger: crashTrigger
        )
        performanceViewModel = PerformanceFeatureViewModel(
            overlayCoordinator: overlayCoordinator
        )
        networkAnalysisViewModel = NetworkAnalysisViewModel(
            overlayCoordinator: overlayCoordinator,
            networkClient: networkClient
        )
        memoryViewModel = MemoryFeatureViewModel(
            overlayCoordinator: overlayCoordinator,
            crashTrigger: crashTrigger,
            leakScenario: leakScenario,
            largeObjectScenario: largeObjectScenario
        )
        remoteLogViewModel = RemoteLogFeatureViewModel(
            overlayCoordinator: overlayCoordinator
        )
    }

    func presentFatalLaunchError(_ error: DemoFatalLaunchError) {
        fatalLaunchError = error
    }

    func confirmFatalLaunchError() {
        fatalLaunchError = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            exit(0)
        }
    }
}
