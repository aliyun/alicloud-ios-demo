import Foundation
import SwiftUI

@MainActor
final class PerformanceFeatureViewModel: ObservableObject {
    private let overlayCoordinator: OverlayCoordinator

    init(overlayCoordinator: OverlayCoordinator) {
        self.overlayCoordinator = overlayCoordinator
    }

    func presentStartupAnalysis() {
        overlayCoordinator.presentAttributedInfoAlert(
            title: "启动分析",
            attributedMessage: Self.startupAnalysisMessage,
            alignment: .leading
        )
    }

    private static var startupAnalysisMessage: AttributedString {
        let bodyColor = UIColor(
            red: 0x5B / 255.0,
            green: 0x64 / 255.0,
            blue: 0x72 / 255.0,
            alpha: 1.0
        )
        let headingColor = UIColor(
            red: 0x2A / 255.0,
            green: 0x2D / 255.0,
            blue: 0x33 / 255.0,
            alpha: 1.0
        )
        let bodyFont = UIFont(name: "PingFangSC-Regular", size: 15) ?? .systemFont(ofSize: 15)
        let headingFont = UIFont(name: "PingFangSC-Semibold", size: 15) ?? .systemFont(ofSize: 15, weight: .semibold)
        let bodyParagraph = NSMutableParagraphStyle()
        bodyParagraph.minimumLineHeight = 24
        bodyParagraph.maximumLineHeight = 24

        let sections: [(String, String)] = [
            ("冷启动", "已在App启动时自动记录"),
            ("热启动", "需将App进行前后台切换"),
            ("查看数据", "所有启动数据均在App退至后台时统一上报，稍后可在 EMAS 控制台查看"),
        ]

        let message = NSMutableAttributedString()
        for (index, section) in sections.enumerated() {
            message.append(NSAttributedString(string: section.0, attributes: [
                .font: headingFont,
                .foregroundColor: headingColor,
            ]))
            message.append(NSAttributedString(string: "\n", attributes: [
                .font: bodyFont,
                .foregroundColor: bodyColor,
                .paragraphStyle: bodyParagraph,
            ]))
            message.append(NSAttributedString(string: section.1, attributes: [
                .font: bodyFont,
                .foregroundColor: bodyColor,
                .paragraphStyle: bodyParagraph,
            ]))
            if index < sections.count - 1 {
                message.append(NSAttributedString(string: "\n", attributes: [
                    .font: bodyFont,
                    .foregroundColor: bodyColor,
                    .paragraphStyle: bodyParagraph,
                ]))
            }
        }

        return AttributedString(message)
    }
}
