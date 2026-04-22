import SwiftUI
import AlicloudApmCore

@MainActor
final class SettingsViewModel: ObservableObject {
    private let settingsStore: SettingsStoreProtocol
    private let toastCenter: ToastCenter
    private let fetchUTDID: () -> String
    private let isSDKStarted: () -> Bool
    private let applyUserSettings: (_ userId: String, _ userNick: String) -> Void

    @Published var userId: String = ""
    @Published var userNick: String = ""
    @Published private(set) var utdidText: String = "获取失败"

    init(
        settingsStore: SettingsStoreProtocol,
        toastCenter: ToastCenter,
        fetchUTDID: @escaping () -> String = {
            EAPMApm.utdid()
        },
        isSDKStarted: @escaping () -> Bool = {
            EAPMApm.apm() != nil
        },
        applyUserSettings: @escaping (_ userId: String, _ userNick: String) -> Void = { userId, userNick in
            EAPMApm.apm()?.setUserId(userId: SettingsStore.normalize(userId) ?? "")
            EAPMApm.apm()?.setUserNick(userNick: SettingsStore.normalize(userNick) ?? "")
        }
    ) {
        self.settingsStore = settingsStore
        self.toastCenter = toastCenter
        self.fetchUTDID = fetchUTDID
        self.isSDKStarted = isSDKStarted
        self.applyUserSettings = applyUserSettings
        refresh()
    }

    func refresh() {
        let settings = settingsStore.loadSettings()
        userId = settings.userId
        userNick = settings.userNick
        let utdid = fetchUTDID()
        utdidText = utdid.isEmpty ? "获取失败" : utdid
    }

    func save() {
        let userSettings = DemoUserSettings(userId: userId, userNick: userNick)

        settingsStore.save(settings: userSettings)

        if isSDKStarted() {
            applyUserSettings(userId, userNick)
        }

        refresh()
        toastCenter.show(message: "设置已保存")
    }
}

struct SettingsFormContent: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoTextField(
                title: "UserID",
                placeholder: "请输入 UserID",
                isEditable: true,
                identifier: "settings.userId",
                text: $viewModel.userId
            )

            DemoTextField(
                title: "用户昵称",
                placeholder: "请输入用户昵称",
                isEditable: true,
                identifier: "settings.userNick",
                text: $viewModel.userNick
            )

            DemoTextField(
                title: "UTDID",
                placeholder: "",
                isEditable: false,
                identifier: "settings.utdid",
                text: .constant(viewModel.utdidText)
            )
        }
    }
}

struct SettingsScreen: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        SecondaryPageLayout(title: "设置") {
            VStack(alignment: .leading, spacing: 0) {
                SettingsFormContent(viewModel: viewModel)

                DemoPrimaryButton(title: "保存设置", isEnabled: true, identifier: "settings.save") {
                    viewModel.save()
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, DemoSpacing.horizontal)
            .padding(.top, DemoSpacing.contentTopSpacing)
        }
        .onAppear {
            viewModel.refresh()
        }
        .dismissKeyboardOnTap()
    }
}
