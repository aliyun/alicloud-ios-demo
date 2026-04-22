import SwiftUI

enum HomeRoute: Hashable {
    case otherCrashTypes
    case pageAnalysis
    case networkAnalysis
}

enum HomeActionKind: String, Hashable, CaseIterable {
    case crash
    case hang
    case customException
    case otherCrashTypes
    case startupAnalysis
    case pageAnalysis
    case networkAnalysis
    case oom
    case memoryLeak
    case largeObject
    case remoteLogFetch
    case remoteLogUpload
}

struct HomeCardModel: Identifiable {
    let id = UUID()
    let title: String
    let kind: HomeActionKind

    var route: HomeRoute? {
        switch kind {
        case .otherCrashTypes:
            return .otherCrashTypes
        case .pageAnalysis:
            return .pageAnalysis
        case .networkAnalysis:
            return .networkAnalysis
        default:
            return nil
        }
    }
}

struct HomeSectionModel: Identifiable {
    let id = UUID()
    let title: String
    let cards: [HomeCardModel]
}

@MainActor
final class HomeViewModel: ObservableObject {
    static let infoBannerText = "触发相关事件，并在 EMAS 控制台 查看上报数据"
    @Published private(set) var sections: [HomeSectionModel] = HomeViewModel.makeSections()

    static func makeSections() -> [HomeSectionModel] {
        [
            HomeSectionModel(
                title: "崩溃分析",
                cards: [
                    HomeCardModel(title: "崩溃", kind: .crash),
                    HomeCardModel(title: "卡顿", kind: .hang),
                    HomeCardModel(title: "自定义异常", kind: .customException),
                    HomeCardModel(title: "其它类型崩溃", kind: .otherCrashTypes),
                ]
            ),
            HomeSectionModel(
                title: "性能分析",
                cards: [
                    HomeCardModel(title: "启动分析", kind: .startupAnalysis),
                    HomeCardModel(title: "页面分析", kind: .pageAnalysis),
                    HomeCardModel(title: "网络分析", kind: .networkAnalysis),
                ]
            ),
            HomeSectionModel(
                title: "内存分析",
                cards: [
                    HomeCardModel(title: "OOM", kind: .oom),
                    HomeCardModel(title: "内存泄漏", kind: .memoryLeak),
                    HomeCardModel(title: "大对象", kind: .largeObject),
                ]
            ),
            HomeSectionModel(
                title: "远程日志",
                cards: [
                    HomeCardModel(title: "日志回捞", kind: .remoteLogFetch),
                    HomeCardModel(title: "主动上报", kind: .remoteLogUpload),
                ]
            ),
        ]
    }
}

struct HomeScreen: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject private var environment: AppEnvironment
    @State private var isShowingSettings = false

    private let columns = [
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
    ]

    var body: some View {
        ZStack {
            HomeBackgroundView().ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    HeroPanel(
                        onTapSettings: { isShowingSettings = true },
                        infoText: HomeViewModel.infoBannerText
                    )
                    .padding(.bottom, 18)

                    ForEach(viewModel.sections) { section in
                        VStack(alignment: .leading, spacing: 0) {
                            SectionTitleView(title: section.title)
                                .padding(.horizontal, DemoSpacing.horizontal)
                                .padding(.bottom, 6)
                                .frame(height: 28)

                            LazyVGrid(columns: columns, spacing: 6) {
                                ForEach(section.cards) { card in
                                    if let route = card.route {
                                        NavigationLink(destination: destinationView(for: route)) {
                                            cardView(for: card)
                                        }
                                        .buttonStyle(.plain)
                                        .accessibilityIdentifier("home.card.\(card.kind.rawValue)")
                                    } else {
                                        Button {
                                            performAction(card.kind)
                                        } label: {
                                            cardView(for: card)
                                        }
                                        .buttonStyle(.plain)
                                        .accessibilityIdentifier("home.card.\(card.kind.rawValue)")
                                    }
                                }
                            }
                            .padding(.horizontal, DemoSpacing.horizontal)
                        }
                        .padding(.bottom, 12)
                    }
                }
                .padding(.bottom, DemoSpacing.bottomPadding)
            }
            .ignoresSafeArea(edges: .top)

            NavigationLink(
                destination: SettingsScreen(viewModel: environment.settingsViewModel),
                isActive: $isShowingSettings
            ) {
                EmptyView()
            }
            .hidden()
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private func destinationView(for route: HomeRoute) -> some View {
        switch route {
        case .otherCrashTypes:
            OtherCrashTypesScreen(viewModel: environment.otherCrashTypesViewModel)
        case .pageAnalysis:
            PageAnalysisScreen()
        case .networkAnalysis:
            NetworkAnalysisScreen(viewModel: environment.networkAnalysisViewModel)
        }
    }

    private func cardView(for card: HomeCardModel) -> some View {
        DemoSecondaryActionButton(
            title: card.title
        )
    }

    private func performAction(_ kind: HomeActionKind) {
        switch kind {
        case .crash:
            environment.crashViewModel.triggerCrash()
        case .hang:
            environment.crashViewModel.triggerHang()
        case .customException:
            environment.crashViewModel.recordCustomExceptions()
        case .startupAnalysis:
            environment.performanceViewModel.presentStartupAnalysis()
        case .oom:
            environment.memoryViewModel.triggerOOM()
        case .memoryLeak:
            environment.memoryViewModel.triggerMemoryLeak()
        case .largeObject:
            environment.memoryViewModel.triggerLargeObject()
        case .remoteLogFetch:
            environment.remoteLogViewModel.captureLogs()
        case .remoteLogUpload:
            environment.remoteLogViewModel.uploadLogs()
        case .pageAnalysis, .otherCrashTypes, .networkAnalysis:
            break
        }
    }
}
