import SwiftUI

enum DemoTheme {
    static let appBackground = Color(hex: 0xF3F4F8)
    static let pageBackground = Color.white
    static let pageTitle = Color(hex: 0x4B4D52)
    static let primaryText = Color(hex: 0x1F2024)
    static let secondaryText = Color(hex: 0x9A9EA8)
    static let placeholderText = Color(hex: 0xC8D0DD)
    static let fieldEditableBackground = Color(hex: 0xF0F2F5)
    static let fieldReadonlyBackground = Color(hex: 0xE1E5EB)
    static let fieldEditableText = Color(hex: 0x4B4D52)
    static let fieldReadonlyText = Color(hex: 0x95A4C2)
    static let sectionIndicator = Color(hex: 0x315CFC)
    static let sectionBorder = Color(hex: 0xE6E8EB)
    static let secondaryButtonBackground = Color(hex: 0xF7F8FB)
    static let primaryGradientStart = Color(hex: 0x4250F7)
    static let primaryGradientEnd = Color(hex: 0x435FF9)
    static let tipBackground = Color(hex: 0xEEF3FF)
    static let tipText = Color(hex: 0x7A8FB8)
    static let tipBorder = Color(hex: 0xD9E4FB)
    static let homeBannerText = Color(hex: 0x7087AD)
    static let homeBannerHighlight = Color(hex: 0x374254)
    static let homeTitle = Color(hex: 0x4B4D52)
    static let homeSubtitle = Color(hex: 0x607B9C)
    static let homeSettings = Color(hex: 0x394153)
    static let overlayDivider = Color(hex: 0xE8EBF2)
    static let overlayMessage = Color(hex: 0x5B6472)
    static let overlayPrimary = Color(hex: 0x315CFC)
    static let overlaySecondary = Color(hex: 0x9AA5B5)
    static let toastBackground = Color(hex: 0x1E2A44, alpha: 0.96)

    static let primaryButtonGradient = LinearGradient(
        colors: [primaryGradientStart, primaryGradientEnd],
        startPoint: UnitPoint(x: 1.0, y: 0.0),
        endPoint: UnitPoint(x: 0.1, y: 1.0)
    )
}

enum DemoSpacing {
    static let horizontal: CGFloat = 16
    static let headerTopPadding: CGFloat = 10
    static let headerTitleSpacing: CGFloat = 4
    static let headerBottomPadding: CGFloat = 20
    static let contentTopSpacing: CGFloat = 4
    static let sectionTop: CGFloat = 20
    static let sectionContent: CGFloat = 14
    static let fieldTitleSpacing: CGFloat = 6
    static let inputVerticalSpacing: CGFloat = 12
    static let inputToButtonSpacing: CGFloat = 20
    static let fieldHeight: CGFloat = 52
    static let actionHeight: CGFloat = 48
    static let primaryButtonHeight: CGFloat = 60
    static let bottomPadding: CGFloat = 32
    static let toastBottomInset: CGFloat = 28
    static let tipVerticalInset: CGFloat = 14
    static let cornerRadius: CGFloat = 8
}

enum DemoFont {
    static let pageTitle = Font.custom("PingFangSC-Medium", size: 22)
    static let sectionTitle = Font.custom("PingFangSC-Medium", size: 18)
    static let fieldTitle = Font.custom("PingFangSC-Regular", size: 18)
    static let body = Font.custom("PingFangSC-Regular", size: 16)
    static let info = Font.custom("PingFangSC-Regular", size: 15)
    static let button = Font.custom("PingFangSC-Semibold", size: 18)
    static let action = Font.custom("PingFangSC-Regular", size: 16)
    static let alertTitle = Font.custom("PingFangSC-Semibold", size: 20)
    static let bottomSheetTitle = Font.custom("PingFangSC-Medium", size: 20)
    static let toast = Font.custom("PingFangSC-Medium", size: 15)
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
