import SwiftUI

struct NetworkAnalysisScreen: View {
    @ObservedObject var viewModel: NetworkAnalysisViewModel

    var body: some View {
        SecondaryPageLayout(title: "网络分析") {
            VStack(alignment: .leading, spacing: 0) {
                TipCardView(text: "请触发不同类型的网络请求。网络分析数据在App退至后台时统一上报，稍后可在 EMAS 控制台查看。")
                    .padding(.top, DemoSpacing.contentTopSpacing)

                SectionTitleView(title: "网络请求")
                    .padding(.top, DemoSpacing.sectionTop)

                DemoTextField(
                    title: "URL",
                    placeholder: "请输入完整URL，默认https://www.aliyun.com",
                    isEditable: !viewModel.isRequestInProgress,
                    identifier: "network.url",
                    text: $viewModel.urlText
                )
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.top, DemoSpacing.sectionContent)

                DemoPrimaryButton(
                    title: viewModel.isRequestInProgress ? "请求中..." : "发送请求",
                    isEnabled: !viewModel.isRequestInProgress,
                    identifier: "network.send"
                ) {
                    viewModel.handleSendTapped()
                }
                .padding(.top, 20)

                SectionTitleView(title: "网络错误")
                    .padding(.top, DemoSpacing.sectionTop)

                HStack(spacing: 6) {
                    compactActionButton(
                        title: "网络错误",
                        identifier: "network.transportError",
                        action: viewModel.handleTransportErrorTapped
                    )
                    compactActionButton(
                        title: "HTTP错误",
                        identifier: "network.httpError",
                        action: viewModel.handleHTTPErrorTapped
                    )
                }
                .padding(.top, DemoSpacing.sectionContent)
                .padding(.bottom, DemoSpacing.bottomPadding)
            }
            .padding(.horizontal, DemoSpacing.horizontal)
        }
        .dismissKeyboardOnTap()
    }

    private func compactActionButton(title: String, identifier: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            DemoSecondaryActionButton(title: title)
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isRequestInProgress)
        .accessibilityIdentifier(identifier)
    }
}
