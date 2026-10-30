import SwiftUI
import shared

struct ContentView: View {
    @StateObject private var koinBootstrap = KoinBootstrap.shared
    @StateObject private var session = SessionViewModelWrapper()
    @AppStorage("rutaxpress.onboarding.completed") private var onboardingCompleted = false
    @State private var welcomeCompleted = false

    var body: some View {
        Group {
            if !koinBootstrap.isReady || session.sessionState?.isRestoring != false {
                AppColors.bg.ignoresSafeArea()
                    .overlay(ProgressView().tint(AppColors.primary))
            } else if let state = session.sessionState, state.isAuthenticated {
                MainTabView(role: state.role)
            } else if !onboardingCompleted && !welcomeCompleted {
                WelcomeView(onStart: { welcomeCompleted = true })
            } else if !onboardingCompleted {
                OnboardingView(onFinish: { onboardingCompleted = true })
            } else {
                AuthView(onAuth: {})
            }
        }
        .task(id: koinBootstrap.isReady) {
            if koinBootstrap.isReady { session.start() }
        }
        .onDisappear {
            session.stop()
        }
    }
}
