import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let options = EAPMOptions(
            appKey: "您的appKey",
            appSecret: "您的appSecret",
            sdkComponents: [CrashAnalysis.self, Performance.self, RemoteLog.self]
        )
        options.userId = "userId"
        options.userNick = "userNick"
        options.channel = "channel"
        options.appRsaSecret = "您的appRsaSecret"
        EAPMSetLoggerLevelDebug()
//        EAPMConfiguration.shared.setLoggerLevel(EAPMLoggerLevel.debug)
        EAPMApm.start(options: options)
        
        return true
    }
}
