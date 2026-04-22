import SwiftUI
import UIKit

struct HomeBackgroundView: View {
    var body: some View {
        GeometryReader { proxy in
            let scale = proxy.size.width / 375.0

            ZStack(alignment: .topLeading) {
                DemoTheme.appBackground

                Image("eapm_home_bg")
                    .resizable()
                    .frame(width: 1160.89 * scale, height: 653.0 * scale)
                    .opacity(0.15)
                    .offset(x: -283.89 * scale, y: 0)
            }
        }
    }
}

struct SecondaryPageLayout<Content: View>: View {
    let title: String
    let content: Content

    @Environment(\.dismiss) private var dismiss

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        ZStack {
            DemoTheme.pageBackground.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    SecondaryPageHeader(title: title) {
                        dismiss()
                    }
                    content
                        .padding(.bottom, DemoSpacing.bottomPadding)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SecondaryPageHeader: View {
    let title: String
    let onBack: () -> Void

    var body: some View {
        HStack(spacing: DemoSpacing.headerTitleSpacing) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(DemoTheme.primaryText)
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.plain)

            Text(pageTitleAttributedText)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, DemoSpacing.horizontal)
        .padding(.top, DemoSpacing.headerTopPadding)
        .padding(.bottom, DemoSpacing.headerBottomPadding)
    }

    private var pageTitleAttributedText: AttributedString {
        let value = NSAttributedString(string: title, attributes: [
            .font: UIFont(name: "PingFangSC-Medium", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .medium),
            .foregroundColor: UIColor(DemoTheme.pageTitle),
            .kern: 0.8,
        ])
        return AttributedString(value)
    }
}

struct SectionTitleView: View {
    let title: String

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(DemoTheme.sectionIndicator)
                .frame(width: 4, height: 20)

            Text(title)
                .font(DemoFont.sectionTitle)
                .foregroundStyle(DemoTheme.pageTitle)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TipCardView: View {
    let text: String
    var backgroundColor: Color = DemoTheme.tipBackground
    var textColor: Color = DemoTheme.tipText
    var borderColor: Color? = nil
    var highlightedRanges: [String] = []
    var highlightColor: Color = DemoTheme.homeBannerHighlight

    var body: some View {
        Text(attributedText)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, DemoSpacing.horizontal)
            .padding(.vertical, DemoSpacing.tipVerticalInset)
            .background(
                RoundedRectangle(cornerRadius: DemoSpacing.cornerRadius, style: .continuous)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DemoSpacing.cornerRadius, style: .continuous)
                    .stroke(borderColor ?? .clear, lineWidth: borderColor == nil ? 0 : 1)
            )
    }

    private var attributedText: AttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.minimumLineHeight = 20
        paragraphStyle.maximumLineHeight = 20

        let attributed = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont(name: "PingFangSC-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular),
            .foregroundColor: UIColor(textColor),
            .paragraphStyle: paragraphStyle,
            .kern: 0.2,
        ])

        for highlight in highlightedRanges {
            let nsRange = (text as NSString).range(of: highlight)
            if nsRange.location != NSNotFound {
                attributed.addAttributes([
                    .font: UIFont(name: "PingFangSC-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold),
                    .foregroundColor: UIColor(highlightColor),
                ], range: nsRange)
            }
        }

        return AttributedString(attributed)
    }
}

struct DemoTextField: View {
    let title: String
    let placeholder: String
    let isEditable: Bool
    let identifier: String?

    @Binding var text: String

    init(
        title: String,
        placeholder: String,
        isEditable: Bool,
        identifier: String? = nil,
        text: Binding<String>
    ) {
        self.title = title
        self.placeholder = placeholder
        self.isEditable = isEditable
        self.identifier = identifier
        self._text = text
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DemoSpacing.fieldTitleSpacing) {
            Text(fieldTitleAttributedText)

            TextField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .font(DemoFont.body)
                    .foregroundColor(DemoTheme.placeholderText)
            )
                .disabled(!isEditable)
                .font(DemoFont.body)
                .foregroundStyle(isEditable ? DemoTheme.fieldEditableText : DemoTheme.fieldReadonlyText)
                .padding(.horizontal, DemoSpacing.horizontal)
                .frame(height: DemoSpacing.fieldHeight)
                .background(
                    RoundedRectangle(cornerRadius: DemoSpacing.cornerRadius, style: .continuous)
                        .fill(isEditable ? DemoTheme.fieldEditableBackground : DemoTheme.fieldReadonlyBackground)
                )
                .accessibilityIdentifier(identifier ?? "")
        }
    }

    private var fieldTitleAttributedText: AttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 24
        paragraphStyle.maximumLineHeight = 24

        let value = NSAttributedString(string: title, attributes: [
            .font: UIFont(name: "PingFangSC-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .regular),
            .foregroundColor: UIColor(DemoTheme.secondaryText),
            .kern: 0.2,
            .paragraphStyle: paragraphStyle,
        ])
        return AttributedString(value)
    }
}

struct DemoPrimaryButton: View {
    let title: String
    let isEnabled: Bool
    let identifier: String?
    let action: () -> Void

    init(
        title: String,
        isEnabled: Bool,
        identifier: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.identifier = identifier
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DemoFont.button)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: DemoSpacing.primaryButtonHeight)
                .background(
                    RoundedRectangle(cornerRadius: DemoSpacing.cornerRadius, style: .continuous)
                        .fill(DemoTheme.primaryButtonGradient)
                )
                .opacity(isEnabled ? 1.0 : 0.55)
        }
        .disabled(!isEnabled)
        .buttonStyle(.plain)
        .accessibilityIdentifier(identifier ?? "")
    }
}

struct DemoSecondaryActionButton: View {
    let title: String

    var body: some View {
        Text(actionAttributedTitle)
            .frame(maxWidth: .infinity)
            .frame(height: DemoSpacing.actionHeight)
            .background(
                RoundedRectangle(cornerRadius: DemoSpacing.cornerRadius, style: .continuous)
                    .fill(DemoTheme.secondaryButtonBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DemoSpacing.cornerRadius, style: .continuous)
                    .stroke(DemoTheme.sectionBorder, lineWidth: 2)
            )
    }

    private var actionAttributedTitle: AttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = 24
        paragraphStyle.maximumLineHeight = 24

        let value = NSAttributedString(string: title, attributes: [
            .font: UIFont(name: "PingFangSC-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor(DemoTheme.primaryText),
            .paragraphStyle: paragraphStyle,
        ])
        return AttributedString(value)
    }
}

struct HeroPanel: View {
    let onTapSettings: () -> Void
    let infoText: String

    var body: some View {
        GeometryReader { proxy in
            let safeTop = max(proxy.safeAreaInsets.top, UIApplication.safeAreaTopInset)
            let imageHeight = ceil(proxy.size.width * 1068.0 / 1500.0)

            ZStack(alignment: .topLeading) {
                Image("eapm_home_hero")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: proxy.size.width, height: imageHeight, alignment: .top)
                    .frame(maxHeight: .infinity, alignment: .top)

                LinearGradient(
                    colors: [Color.white.opacity(0.0), DemoTheme.appBackground],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)

                VStack(alignment: .leading, spacing: 0) {
                    Text(titleAttributedText)
                        .frame(width: 220, alignment: .leading)

                    Text(subtitleAttributedText)
                        .frame(width: 208, alignment: .leading)
                        .padding(.top, 12)
                }
                .padding(.leading, DemoSpacing.horizontal)
                .padding(.top, safeTop + 58)

                TipCardView(
                    text: infoText,
                    backgroundColor: Color(hex: 0xEBF0FF),
                    textColor: DemoTheme.homeBannerText,
                    borderColor: DemoTheme.tipBorder,
                    highlightedRanges: ["EMAS 控制台", "EMAS 控制台"],
                    highlightColor: DemoTheme.homeBannerHighlight
                )
                .padding(.horizontal, DemoSpacing.horizontal)
                .frame(maxHeight: .infinity, alignment: .bottom)

                Button(action: onTapSettings) {
                    HStack(spacing: 3) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(Color(hex: 0x5D6573))

                        Text(settingsAttributedText)
                    }
                    .padding(.vertical, 6)
                    .padding(.leading, 6)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("home.settings")
                .padding(.trailing, DemoSpacing.horizontal)
                .padding(.top, max(safeTop - 10, 0))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
        }
        .frame(height: 332)
    }

    private var subtitleAttributedText: AttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.minimumLineHeight = 20
        paragraphStyle.maximumLineHeight = 20

        let value = NSAttributedString(string: "欢迎来到阿里云移动监控 Demo，开始你的调试吧~", attributes: [
            .font: UIFont(name: "PingFangSC-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(DemoTheme.homeSubtitle),
            .paragraphStyle: paragraphStyle,
            .kern: 0.2,
        ])
        return AttributedString(value)
    }

    private var titleAttributedText: AttributedString {
        let value = NSAttributedString(string: "移动监控 Demo", attributes: [
            .font: UIFont(name: "PingFangSC-Medium", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .medium),
            .foregroundColor: UIColor(DemoTheme.homeTitle),
            .kern: 0.8,
        ])
        return AttributedString(value)
    }

    private var settingsAttributedText: AttributedString {
        let value = NSAttributedString(string: "设置", attributes: [
            .font: UIFont(name: "PingFangSC-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(DemoTheme.homeSettings),
            .kern: 1.2,
        ])
        return AttributedString(value)
    }
}

struct GuideBottomSheet: View {
    let state: DemoGuideSheetState
    let onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(bottomSheetTitleAttributedText)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 24)
                .padding(.top, 24)

            statusBanner
                .padding(.horizontal, DemoSpacing.horizontal)
                .padding(.top, 18)

            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(state.guideItems.enumerated()), id: \.offset) { index, item in
                    guideRow(text: item, index: state.guideItems.count > 1 ? index + 1 : nil)
                }
            }
            .padding(.horizontal, DemoSpacing.horizontal)
            .padding(.top, 20)

            DemoPrimaryButton(title: state.confirmTitle, isEnabled: true) {
                onDismiss()
            }
            .padding(.horizontal, DemoSpacing.horizontal)
            .padding(.top, 28)
            .padding(.bottom, max(UIApplication.safeAreaBottomInset - 10, 12))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedCorner(radius: 22, corners: [.topLeft, .topRight])
                .fill(Color.white.opacity(0.98))
                .ignoresSafeArea()
        )
    }

    private var statusBanner: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: 0xD9F8D2), Color(hex: 0xD6F8E7)],
                startPoint: .leading,
                endPoint: .trailing
            )

            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(Color(hex: 0x2DA45B))
                Text(state.statusText)
                    .font(DemoFont.toast)
                    .foregroundStyle(Color(hex: 0x2DA45B))
            }
        }
        .frame(height: 40)
        .clipShape(RoundedRectangle(cornerRadius: DemoSpacing.cornerRadius, style: .continuous))
    }

    @ViewBuilder
    private func guideRow(text: String, index: Int?) -> some View {
        HStack(alignment: .top, spacing: 12) {
            if let index {
                Text("\(index)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(width: 18, height: 18)
                    .background(
                        Circle().fill(Color(hex: 0x4D61FF))
                    )
                    .padding(.top, 2)
            }

            Text(guideBodyAttributedText(text))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var bottomSheetTitleAttributedText: AttributedString {
        let value = NSAttributedString(string: state.title, attributes: [
            .font: UIFont(name: "PingFangSC-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium),
            .foregroundColor: UIColor(DemoTheme.pageTitle),
            .kern: 0.4,
        ])
        return AttributedString(value)
    }

    private func guideBodyAttributedText(_ text: String) -> AttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 24
        paragraphStyle.maximumLineHeight = 24
        let value = NSAttributedString(string: text, attributes: [
            .font: UIFont(name: "PingFangSC-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor(hex: 0x63728D),
            .paragraphStyle: paragraphStyle,
        ])
        return AttributedString(value)
    }
}

struct DemoAlertOverlay: View {
    let state: DemoAlertState
    let onDismiss: () -> Void
    @State private var pendingAction: (() -> Void)?

    var body: some View {
        ZStack {
            BlurBackdrop()
            Color.black.opacity(0.08).ignoresSafeArea()

            VStack(spacing: 0) {
                Text(state.title)
                    .font(DemoFont.alertTitle)
                    .foregroundStyle(DemoTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .accessibilityIdentifier("overlay.alert.title")

                Group {
                    if let attributedMessage = state.attributedMessage {
                        Text(attributedMessage)
                    } else {
                        Text(state.message)
                            .font(DemoFont.info)
                            .foregroundStyle(DemoTheme.overlayMessage)
                    }
                }
                    .multilineTextAlignment(state.messageAlignment)
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                    .accessibilityIdentifier("overlay.alert.message")

                Rectangle()
                    .fill(DemoTheme.overlayDivider)
                    .frame(height: 1)
                    .padding(.top, 18)

                HStack(spacing: 0) {
                    if let secondaryAction = state.secondaryAction {
                        alertButton(for: secondaryAction)
                        Rectangle()
                            .fill(DemoTheme.overlayDivider)
                            .frame(width: 1)
                        alertButton(for: state.primaryAction)
                    } else {
                        alertButton(for: state.primaryAction)
                    }
                }
                .frame(height: 52)
            }
            .frame(maxWidth: min(UIScreen.main.bounds.width - 32, 344))
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.95))
            )
        }
        .onDisappear {
            guard let pendingAction else { return }
            self.pendingAction = nil
            pendingAction()
        }
    }

    private func alertButton(for action: DemoAlertAction) -> some View {
        Button {
            pendingAction = action.handler
            onDismiss()
        } label: {
            Text(action.title)
                .font(action.style == .primary ? DemoFont.button : Font.custom("PingFangSC-Regular", size: 18))
                .foregroundStyle(buttonColor(for: action.style))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(accessibilityIdentifier(for: action))
    }

    private func buttonColor(for style: DemoAlertActionStyle) -> Color {
        switch style {
        case .primary, .destructive:
            return DemoTheme.overlayPrimary
        case .secondary:
            return DemoTheme.overlaySecondary
        }
    }

    private func accessibilityIdentifier(for action: DemoAlertAction) -> String {
        switch action.style {
        case .primary, .destructive:
            return "overlay.alert.primary"
        case .secondary:
            return "overlay.alert.secondary"
        }
    }
}

struct ToastBanner: View {
    let message: String

    var body: some View {
        Text(message)
            .font(DemoFont.toast)
            .foregroundStyle(Color.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(DemoTheme.toastBackground)
            )
            .padding(.horizontal, 24)
    }
}

struct BlurBackdrop: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.alpha = 0.72
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardModifier())
    }
}

private struct DismissKeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}

private extension UIApplication {
    static var safeAreaTopInset: CGFloat {
        shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .safeAreaInsets.top ?? 0
    }

    static var safeAreaBottomInset: CGFloat {
        shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .safeAreaInsets.bottom ?? 0
    }
}

private extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}
