import Combine
import Foundation
import UIKit

@MainActor
final class NetworkAnalysisViewModel: ObservableObject {
    private let overlayCoordinator: OverlayCoordinator
    private let networkClient: NetworkClient

    @Published var urlText: String = ""
    @Published private(set) var isRequestInProgress = false

    init(overlayCoordinator: OverlayCoordinator, networkClient: NetworkClient) {
        self.overlayCoordinator = overlayCoordinator
        self.networkClient = networkClient
    }

    func handleSendTapped() {
        let normalizedURL = normalizedURLString(urlText) ?? "https://www.aliyun.com"
        sendRequest(urlString: normalizedURL)
    }

    func handleTransportErrorTapped() {
        sendRequest(urlString: "https://demo-network-error.invalid/")
    }

    func handleHTTPErrorTapped() {
        sendRequest(urlString: "https://postman-echo.com/status/500")
    }

    func sendRequest(urlString: String) {
        guard !isRequestInProgress else {
            return
        }

        guard let request = makeRequest(from: urlString) else {
            overlayCoordinator.presentInfoAlert(title: "提示", message: "请输入有效的完整 HTTP(S) URL")
            return
        }

        isRequestInProgress = true

        networkClient.data(for: request) { [weak self] result in
            guard let self else {
                return
            }

            self.isRequestInProgress = false

            switch result {
            case let .success((_, response)):
                let statusCode = response.statusCode
                let isSuccess = (200...299).contains(statusCode)
                self.presentResult(
                    urlString: request.url?.absoluteString ?? urlString,
                    isSuccess: isSuccess,
                    statusCode: statusCode
                )
            case let .failure(error):
                self.presentResult(
                    urlString: request.url?.absoluteString ?? urlString,
                    isSuccess: false,
                    statusCode: nil,
                    errorDescription: error.localizedDescription
                )
            }
        }
    }

    func resultMessage(
        urlString: String,
        isSuccess: Bool,
        statusCode: Int?,
        errorDescription: String? = nil
    ) -> AttributedString {
        let bodyFont = UIFont(name: "PingFangSC-Regular", size: 15) ?? .systemFont(ofSize: 15, weight: .regular)
        let symbolFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let labelColor = UIColor(
            red: 0x5B / 255.0,
            green: 0x64 / 255.0,
            blue: 0x72 / 255.0,
            alpha: 1.0
        )
        let successColor = UIColor(
            red: 0x24 / 255.0,
            green: 0xB3 / 255.0,
            blue: 0x6B / 255.0,
            alpha: 1.0
        )
        let failureColor = UIColor(
            red: 0xF0 / 255.0,
            green: 0x44 / 255.0,
            blue: 0x38 / 255.0,
            alpha: 1.0
        )
        let statusSymbol = isSuccess ? "✓" : "✕"
        let statusText = isSuccess ? "Success" : "Failure"
        let statusColor = isSuccess ? successColor : failureColor
        let statusCodeText = statusCode.map(String.init) ?? ""

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.minimumLineHeight = 24
        paragraphStyle.maximumLineHeight = 24

        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont,
            .foregroundColor: labelColor,
            .paragraphStyle: paragraphStyle,
        ]
        let symbolAttributes: [NSAttributedString.Key: Any] = [
            .font: symbolFont,
            .foregroundColor: statusColor,
            .paragraphStyle: paragraphStyle,
        ]
        let statusAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont,
            .foregroundColor: statusColor,
            .paragraphStyle: paragraphStyle,
        ]

        let message = NSMutableAttributedString()
        message.append(NSAttributedString(string: "URL: \(urlString)\n", attributes: bodyAttributes))
        message.append(NSAttributedString(string: "Result: ", attributes: bodyAttributes))
        message.append(NSAttributedString(string: statusSymbol, attributes: symbolAttributes))
        message.append(NSAttributedString(string: " \(statusText)\n", attributes: statusAttributes))
        message.append(NSAttributedString(string: "Status Code: \(statusCodeText)\n", attributes: bodyAttributes))
        message.append(NSAttributedString(string: "\n请切换至后台触发上报，稍后可在 EMAS 控制台查看。", attributes: bodyAttributes))
        return AttributedString(message)
    }

    private func normalizedURLString(_ value: String?) -> String? {
        SettingsStore.normalize(value)
    }

    private func makeRequest(from value: String) -> URLRequest? {
        guard
            let components = URLComponents(string: value),
            let scheme = components.scheme?.lowercased(),
            let host = components.host,
            !host.isEmpty,
            ["http", "https"].contains(scheme),
            let url = components.url
        else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 15
        return request
    }

    private func presentResult(
        urlString: String,
        isSuccess: Bool,
        statusCode: Int?,
        errorDescription: String? = nil
    ) {
        overlayCoordinator.presentAttributedInfoAlert(
            title: "网络请求",
            attributedMessage: resultMessage(
                urlString: urlString,
                isSuccess: isSuccess,
                statusCode: statusCode,
                errorDescription: errorDescription
            ),
            alignment: .leading
        )
    }
}
