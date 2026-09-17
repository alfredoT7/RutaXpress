import SwiftUI

struct LoginView: View {
    @ObservedObject var wrapper: AuthViewModelWrapper
    let onLoginSuccess: () -> Void

    @State private var identifier = ""
    @State private var password = ""
    @State private var showError = false
    @FocusState private var focused: LoginField?

    private enum LoginField { case identifier, password }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xl) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Bienvenido de vuelta")
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.text)
                Text("Ingresa a tu cuenta de pasajero")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.muted)
            }

            VStack(spacing: AppSpacing.md) {
                AuthField(
                    icon: "envelope",
                    placeholder: "Correo o usuario",
                    text: $identifier,
                    submitLabel: .next,
                    onSubmit: { focused = .password }
                )
                .focused($focused, equals: .identifier)

                AuthField(
                    icon: "lock",
                    placeholder: "Contraseña",
                    text: $password,
                    isSecure: true,
                    submitLabel: .done,
                    onSubmit: { submitLogin() }
                )
                .focused($focused, equals: .password)
            }

            HStack {
                Spacer()
                Button("¿Olvidaste tu contraseña?") {}
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primary)
            }

            if wrapper.uiState.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                PrimaryButton(label: "Iniciar sesión", action: submitLogin)
            }

            SocialDivider()

            SocialButtons()

            Spacer()
        }
        .padding(.horizontal, AppSpacing.xl)
        .padding(.top, AppSpacing.sm)
        .onChange(of: wrapper.uiState.isLoginSuccess) { success in
            if success {
                wrapper.resetSuccess()
                onLoginSuccess()
            }
        }
        .onChange(of: wrapper.uiState.error) { error in
            if error != nil { showError = true }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { wrapper.clearError() }
        } message: {
            Text(wrapper.uiState.error ?? "")
        }
    }

    private func submitLogin() {
        onLoginSuccess()
    }
}

#Preview {
    ZStack {
        AppColors.bg.ignoresSafeArea()
        LoginView(wrapper: AuthViewModelWrapper(), onLoginSuccess: {})
    }
}
