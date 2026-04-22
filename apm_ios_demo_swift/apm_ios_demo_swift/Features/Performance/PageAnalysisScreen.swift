import SwiftUI
import UIKit

private struct PageAnalysisSection: Identifiable {
    let title: String
    let body: String

    var id: String { title }
}

struct PageAnalysisContentView: View {
    let onBack: () -> Void

    private let sections: [PageAnalysisSection] = [
        PageAnalysisSection(
            title: "APM 性能监控",
            body: "EMAS APM（Application Performance Management）是面向移动端的性能监控产品，提供崩溃分析、性能分析、远程日志等核心能力，帮助开发者快速定位和解决线上问题。"
        ),
        PageAnalysisSection(
            title: "崩溃分析",
            body: "支持 Java Crash、Native Crash、ANR 等多种崩溃类型的自动采集与分析。提供完整的崩溃堆栈信息，支持符号表自动反解，帮助开发者快速定位崩溃根因。"
        ),
        PageAnalysisSection(
            title: "性能分析",
            body: "提供启动速度、页面加载、帧率监控、卡顿检测等全方位性能数据采集能力。支持 P50/P90/P99 分位数统计，帮助开发者系统性地优化应用性能。"
        ),
        PageAnalysisSection(
            title: "网络监控",
            body: "自动采集 HTTP/HTTPS 请求的全链路耗时数据，包括 DNS 解析、TCP 连接、TLS 握手、首字节时间等各阶段耗时。支持慢请求分析和错误请求统计。"
        ),
        PageAnalysisSection(
            title: "内存分析",
            body: "提供内存泄漏检测、大内存分配监控、OOM 崩溃分析等能力。支持 Activity/Fragment 泄漏检测，帮助开发者及时发现和修复内存问题。"
        ),
        PageAnalysisSection(
            title: "远程日志",
            body: "支持远程日志拉取、日志级别动态调整、日志检索等能力。开发者可以针对特定设备或用户下发日志拉取任务，无需用户配合即可获取详细的运行日志。"
        ),
        PageAnalysisSection(
            title: "多端支持",
            body: "EMAS APM 支持 Android、iOS、HarmonyOS NEXT、H5、Flutter 等多个平台，提供统一的监控体验和数据分析能力。一次接入，全平台覆盖。"
        ),
    ]

    var body: some View {
        ZStack {
            DemoTheme.pageBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    SecondaryPageHeader(title: "页面分析", onBack: onBack)

                    VStack(alignment: .leading, spacing: 0) {
                        TipCardView(text: "请滑动页面。页面分析数据在App退至后台时统一上报，稍后可在 EMAS 控制台查看。")
                            .padding(.top, DemoSpacing.contentTopSpacing)

                        HStack(alignment: .center, spacing: 10) {
                            Image("emas_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 34, height: 26)

                            Text(brandText)
                                .accessibilityIdentifier("pageAnalysis.brand")
                        }
                        .padding(.horizontal, DemoSpacing.horizontal)
                        .padding(.top, DemoSpacing.sectionTop)

                        Text(bodyText("EMAS（Enterprise Mobile Application Service）是阿里云面向移动研发领域，提供一站式移动应用研发管理服务。覆盖开发、测试、运维、运营四个环节，帮助企业快速搭建稳定高质量的移动应用。"))
                            .padding(.horizontal, DemoSpacing.horizontal)
                            .padding(.top, DemoSpacing.sectionContent)

                        ForEach(sections) { section in
                            VStack(alignment: .leading, spacing: 0) {
                                Text(section.title)
                                    .font(DemoFont.sectionTitle)
                                    .foregroundStyle(DemoTheme.primaryText)
                                    .padding(.bottom, 8)

                                Text(bodyText(section.body))
                            }
                            .padding(.horizontal, DemoSpacing.horizontal)
                            .padding(.top, DemoSpacing.sectionTop)
                        }
                    }
                    .padding(.bottom, DemoSpacing.bottomPadding)
                }
            }
        }
        .navigationBarHidden(true)
    }

    private var brandText: AttributedString {
        AttributedString(
            NSAttributedString(
                string: "阿里云EMAS",
                attributes: [
                    .font: UIFont(name: "PingFangSC-Medium", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .medium),
                    .foregroundColor: UIColor(DemoTheme.primaryText),
                    .kern: 1.6,
                ]
            )
        )
    }

    private func bodyText(_ text: String) -> AttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 24
        paragraphStyle.maximumLineHeight = 24

        return AttributedString(
            NSAttributedString(
                string: text,
                attributes: [
                    .font: UIFont(name: "PingFangSC-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular),
                    .foregroundColor: UIColor(
                        red: 0x5A / 255.0,
                        green: 0x61 / 255.0,
                        blue: 0x6E / 255.0,
                        alpha: 1.0
                    ),
                    .paragraphStyle: paragraphStyle,
                ]
            )
        )
    }
}

@objc(EAPMDemoPageAnalysisViewController)
final class PageAnalysisHostingController: UIHostingController<PageAnalysisContentView> {
    init() {
        super.init(rootView: PageAnalysisContentView(onBack: {}))
        title = ""
        navigationItem.hidesBackButton = true
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        rootView = PageAnalysisContentView { [weak self] in
            self?.handleBack()
        }
    }

    private func handleBack() {
        if let navigationController {
            navigationController.popViewController(animated: true)
            return
        }
        dismiss(animated: true)
    }
}

struct PageAnalysisScreen: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PageAnalysisHostingController {
        PageAnalysisHostingController()
    }

    func updateUIViewController(_ uiViewController: PageAnalysisHostingController, context: Context) {}
}
