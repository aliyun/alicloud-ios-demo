import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, 
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let options = EAPMOptions(
            appKey: "335494301",
            appSecret: "aadb46b847d24dc68700c85e4bd6c53a",
            sdkComponents: [CrashAnalysis.self, Performance.self, RemoteLog.self]
        )
        options.userId = "userId"
        options.userNick = "userNick"
        options.channel = "channel"
        options.appRsaSecret = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC5X9TxRFRRMNLfwCUw/01jzmz7Gm7JPy2CFkXrNl0eilkX92+Mw1VFiuvjXB9bA43ZO+CN39KeiTOCP7mwhofdQTjVR/48FZ3c751p52idDXEhG2/boW3wUxvtSA2U33nm16g5UnLzjcjDAre29lFvGYLNv1nxnDyB4wLjmD9/cQIDAQAB"
        EAPMSetLoggerLevelDebug()
//        EAPMConfiguration.shared.setLoggerLevel(EAPMLoggerLevel.debug)
        EAPMApm.start(options: options)
        
        return true
    }
}
