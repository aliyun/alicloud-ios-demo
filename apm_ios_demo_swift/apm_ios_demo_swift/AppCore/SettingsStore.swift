import Foundation

protocol SettingsStoreProtocol {
    func loadSettings() -> DemoUserSettings
    func save(settings: DemoUserSettings)
}

final class SettingsStore: SettingsStoreProtocol {
    static let userIDKey = "kDemoUserId"
    static let userNickKey = "kDemoUserNick"

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadSettings() -> DemoUserSettings {
        DemoUserSettings(
            userId: Self.normalize(defaults.string(forKey: Self.userIDKey)) ?? "",
            userNick: Self.normalize(defaults.string(forKey: Self.userNickKey)) ?? ""
        )
    }

    func save(settings: DemoUserSettings) {
        if let normalizedUserId = Self.normalize(settings.userId) {
            defaults.set(normalizedUserId, forKey: Self.userIDKey)
        } else {
            defaults.removeObject(forKey: Self.userIDKey)
        }

        if let normalizedUserNick = Self.normalize(settings.userNick) {
            defaults.set(normalizedUserNick, forKey: Self.userNickKey)
        } else {
            defaults.removeObject(forKey: Self.userNickKey)
        }
    }

    static func normalize(_ value: String?) -> String? {
        guard let value else {
            return nil
        }

        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
