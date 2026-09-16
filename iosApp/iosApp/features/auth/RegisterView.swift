import SwiftUI

struct RegisterView: View {
    @ObservedObject var wrapper: AuthViewModelWrapper
    let onRegisterSuccess: () -> Void

    @State private var name = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var localError: String? = nil
    @FocusState private var focused: RegisterField?

    private enum RegisterField { case name, username, email, password, confirm }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Crea tu cuenta")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.text)
                    Text("Únete como pasajero de RutaXpress")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.muted)
                }

                VStack(spacing: AppSpacing.md) {
                    AuthField(
                        icon: "person",
                        placeholder: "Nombre completo",
                        text: $name,
                        submitLabel: .next,
                        onSubmit: { focused = .username }
                    )
                    .focused($focused, equals: .name)

                    AuthField(
                        icon: "at",
                        placeholder: "Nombre de usuario",
                        text: $username,
                        submitLabel: .next,
                        onSubmit: { focused = .email }
                    )
                    .focused($focused, equals: .username)

                    AuthField(
                        icon: "envelope",
                        placeholder: "Correo electrónico",
                        text: $email,
                        submitLabel: .next,
                        onSubmit: { focused = .password }
                    )
                    .focused($focused, equals: .email)

                    AuthField(
                        icon: "lock",
                        placeholder: "Contraseña",
                        text: $password,
                        isSecure: true,
                        submitLabel: .next,
                        onSubmit: { focused = .confirm }
                    )
                    .focused($focused, equals: .password)

                    AuthField(
                        icon: "lock.fill",
                        placeholder: "Confirmar contraseña",
                        text: $confirmPassword,
                        isSecure: true,
                        submitLabel: .done,
                        onSubmit: { submitRegister() }
                    )
                    .focused($focused, equals: .confirm)
                }

                if wrapper.uiState.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    PrimaryButton(label: "Registrarse", action: submitRegister)
                }

                SocialDivider()

                SocialButtons()

                Text("Al registrarte aceptas nuestros Términos de uso y Política de privacidad.")
                    .font(AppFonts.footnote)
                    .foregroundColor(AppColors.muted)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, AppSpacing.xxl)
        }
        .scrollDismissesKeyboard(.immediately)
        .onChange(of: wrapper.uiState.isRegisterSuccess) { success in
            if success {
                wrapper.resetSuccess()
                onRegisterSuccess()
            }
        }
        .onChange(of: wrapper.uiState.error) { error in
            if error != nil { showError = true }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {
                localError = nil
                wrapper.clearError()
            }
        } message: {
            Text(localError ?? wrapper.uiState.error ?? "")
        }
    }

    private func submitRegister() {
        guard password == confirmPassword else {
            localError = "Las contraseñas no coinciden"
            showError = true
            return
        }
        onRegisterSuccess()
    }
}

#Preview {
    ZStack {
        AppColors.bg.ignoresSafeArea()
        RegisterView(wrapper: AuthViewModelWrapper(), onRegisterSuccess: {})
    }
}
