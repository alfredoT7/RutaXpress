import SwiftUI

struct ContentView: View {
    @StateObject private var koinBootstrap = KoinBootstrap.shared
    @State private var splashDone = false
    @State private var onboardingDone = false
    @State private var authDone = false

    var body: some View {
        if !splashDone {
            WelcomeView(onStart: { splashDone = true })
        } else if !onboardingDone {
            OnboardingView(onFinish: { onboardingDone = true })
        } else if !authDone {
            if koinBootstrap.isReady {
                AuthView(onAuth: { authDone = true })
            } else {
                AppColors.bg.ignoresSafeArea()
                    .overlay(ProgressView().tint(AppColors.primary))
            }
        } else {
            MainTabView()
        }
    }
}
