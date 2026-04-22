import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var environment: AppEnvironment

    var body: some View {
        ContentRootView(
            environment: environment,
            overlayCoordinator: environment.overlayCoordinator,
            toastCenter: environment.toastCenter
        )
    }
}

private struct ContentRootView: View {
    @ObservedObject var environment: AppEnvironment
    @ObservedObject var overlayCoordinator: OverlayCoordinator
    @ObservedObject var toastCenter: ToastCenter

    var body: some View {
        NavigationView {
            HomeScreen(viewModel: environment.homeViewModel)
                .environmentObject(environment)
        }
        .navigationViewStyle(.stack)
        .overlay {
            if let state = overlayCoordinator.alert {
                DemoAlertOverlay(state: state) {
                    overlayCoordinator.dismissAlert()
                }
            }
        }
        .overlay(alignment: .bottom) {
            if let state = overlayCoordinator.guideSheet {
                ZStack(alignment: .bottom) {
                    BlurBackdrop()
                        .ignoresSafeArea()
                    Color.black.opacity(0.18)
                        .ignoresSafeArea()

                    Color.clear
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                        .onTapGesture {
                            overlayCoordinator.dismissGuide()
                        }

                    GuideBottomSheet(state: state) {
                        overlayCoordinator.dismissGuide()
                    }
                }
                .transition(.opacity)
            }
        }
        .overlay(alignment: .bottom) {
            if let toast = toastCenter.toast {
                ToastBanner(message: toast.message)
                    .padding(.bottom, DemoSpacing.toastBottomInset)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .alert(item: $environment.fatalLaunchError) { error in
            Alert(
                title: Text(error.title),
                message: Text(error.message),
                dismissButton: .destructive(Text("确认退出")) {
                    environment.confirmFatalLaunchError()
                }
            )
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.88), value: toastCenter.toast)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppEnvironment.shared)
}
