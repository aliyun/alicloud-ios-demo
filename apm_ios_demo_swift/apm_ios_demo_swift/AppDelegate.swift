import UIKit
import AlicloudApmCore
import AlicloudApmCrashAnalysis
import AlicloudApmPerformance
import AlicloudApmRemoteLog
import AlicloudApmMemAlloc
import AlicloudApmMemLeak

// 请前往 EMAS 控制台获取应用配置，在此替换。
private let demoApmAppKey = ""
private let demoApmAppSecret = ""
private let demoApmAppRsaSecret = ""

@MainActor
final class AppDelegate: UIResponder, UIApplicationDelegate {
    private let settingsStore = SettingsStore()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let configuration = DemoConfiguration(
            appKey: demoApmAppKey,
            appSecret: demoApmAppSecret,
            appRsaSecret: demoApmAppRsaSecret
        )

        guard configuration.isValid else {
            AppEnvironment.shared.presentFatalLaunchError(.missingConfiguration)
            return true
        }

        let settings = settingsStore.loadSettings()
        let options = EAPMOptions(
            appKey: configuration.appKey,
            appSecret: configuration.appSecret,
            sdkComponents: [
                CrashAnalysis.self,
                Performance.self,
                RemoteLog.self,
                MemAlloc.self,
                MemLeak.self,
            ]
        )
        options.userId = SettingsStore.normalize(settings.userId) ?? ""
        options.userNick = SettingsStore.normalize(settings.userNick) ?? ""
        options.channel = "dev"
        options.appRsaSecret = configuration.appRsaSecret

        EAPMApm.start(options: options)
        return true
    }
}
