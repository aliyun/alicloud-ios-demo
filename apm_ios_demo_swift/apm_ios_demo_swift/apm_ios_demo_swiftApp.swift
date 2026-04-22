import SwiftUI

@main
struct apm_ios_demo_swift: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var environment = AppEnvironment.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(environment)
        }
    }
}
