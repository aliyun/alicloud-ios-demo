import Foundation

struct DemoConfiguration: Equatable {
    var appKey: String
    var appSecret: String
    var appRsaSecret: String

    var isValid: Bool {
        !appKey.isEmpty && !appSecret.isEmpty && !appRsaSecret.isEmpty
    }
}

struct DemoUserSettings: Equatable {
    var userId: String
    var userNick: String
}
