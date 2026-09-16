import SwiftUI

enum AuthTab: Hashable { case login, register }

struct AuthView: View {
    let onAuth: () -> Void
    @State private var tab: AuthTab = .login
    @StateObject private var viewModelWrapper = AuthViewModelWrapper()

    var body: some View {
        ZStack {
            AppColors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: AppSpacing.sm) {
                    Image("rutax-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .padding(.top, AppSpacing.xxl)

                    HStack(spacing: 0) {
                        Text("RUTA")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(AppColors.text)
                        Text("X")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(AppColors.primary)
                    }
                }
                .padding(.bottom, AppSpacing.xl)

                Picker("", selection: $tab) {
                    Text("Iniciar sesión").tag(AuthTab.login)
                    Text("Registrarse").tag(AuthTab.register)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, AppSpacing.xl)
                .padding(.bottom, AppSpacing.xl)

                if tab == .login {
                    LoginView(wrapper: viewModelWrapper, onLoginSuccess: onAuth)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                } else {
                    RegisterView(wrapper: viewModelWrapper, onRegisterSuccess: onAuth)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                }
            }
        }
        .onTapGesture { UIApplication.hideKeyboard() }
    }
}

#Preview {
    AuthView(onAuth: {})
}
