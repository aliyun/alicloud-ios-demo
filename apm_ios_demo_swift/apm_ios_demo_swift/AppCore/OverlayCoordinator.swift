import Foundation
import SwiftUI

enum DemoAlertActionStyle {
    case primary
    case secondary
    case destructive
}

struct DemoAlertAction {
    let title: String
    let style: DemoAlertActionStyle
    let handler: (() -> Void)?
}

struct DemoAlertState: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let attributedMessage: AttributedString?
    let messageAlignment: TextAlignment
    let primaryAction: DemoAlertAction
    let secondaryAction: DemoAlertAction?
}

struct DemoGuideSheetState: Identifiable {
    let id = UUID()
    let title: String
    let statusText: String
    let guideItems: [String]
    let confirmTitle: String
}

struct DemoToastState: Identifiable, Equatable {
    let id = UUID()
    let message: String
}

final class ToastCenter: ObservableObject {
    @Published private(set) var toast: DemoToastState?

    private var dismissWorkItem: DispatchWorkItem?

    func show(message: String, duration: TimeInterval = 2.2) {
        dismissWorkItem?.cancel()
        toast = DemoToastState(message: message)

        let workItem = DispatchWorkItem { [weak self] in
            self?.toast = nil
        }
        dismissWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)
    }

    func dismiss() {
        dismissWorkItem?.cancel()
        toast = nil
    }
}

final class OverlayCoordinator: ObservableObject {
    @Published var alert: DemoAlertState?
    @Published var guideSheet: DemoGuideSheetState?

    func presentAlert(
        title: String,
        message: String,
        attributedMessage: AttributedString? = nil,
        messageAlignment: TextAlignment = .center,
        primaryAction: DemoAlertAction,
        secondaryAction: DemoAlertAction? = nil
    ) {
        alert = DemoAlertState(
            title: title,
            message: message,
            attributedMessage: attributedMessage,
            messageAlignment: messageAlignment,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction
        )
    }

    func presentInfoAlert(title: String, message: String) {
        presentAlert(
            title: title,
            message: message,
            messageAlignment: .center,
            primaryAction: DemoAlertAction(title: "知道了", style: .primary, handler: nil)
        )
    }

    func presentAttributedInfoAlert(title: String, attributedMessage: AttributedString, alignment: TextAlignment = .leading) {
        presentAlert(
            title: title,
            message: String(attributedMessage.characters),
            attributedMessage: attributedMessage,
            messageAlignment: alignment,
            primaryAction: DemoAlertAction(title: "知道了", style: .primary, handler: nil)
        )
    }

    func presentConfirmation(
        title: String,
        message: String,
        confirmTitle: String = "确定",
        confirmStyle: DemoAlertActionStyle = .primary,
        onConfirm: @escaping () -> Void
    ) {
        presentAlert(
            title: title,
            message: message,
            messageAlignment: .center,
            primaryAction: DemoAlertAction(title: confirmTitle, style: confirmStyle, handler: onConfirm),
            secondaryAction: DemoAlertAction(title: "取消", style: .secondary, handler: nil)
        )
    }

    func presentGuide(title: String, statusText: String, guideItems: [String], confirmTitle: String = "我知道了") {
        guideSheet = DemoGuideSheetState(
            title: title,
            statusText: statusText,
            guideItems: guideItems,
            confirmTitle: confirmTitle
        )
    }

    func dismissAlert() {
        alert = nil
    }

    func dismissGuide() {
        guideSheet = nil
    }
}
