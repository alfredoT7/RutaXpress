import SwiftUI
import AuthenticationServices

// MARK: - Field

struct AuthField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var submitLabel: SubmitLabel = .done
    var onSubmit: () -> Void = {}

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(isFocused ? AppColors.primary : AppColors.muted)
                .frame(width: 20)

            if isSecure {
                SecureField("", text: $text, prompt:
                    Text(placeholder).foregroundColor(AppColors.text.opacity(0.35))
                )
                .font(AppFonts.body)
                .foregroundColor(AppColors.text)
                .submitLabel(submitLabel)
                .onSubmit(onSubmit)
                .focused($isFocused)
            } else {
                TextField("", text: $text, prompt:
                    Text(placeholder).foregroundColor(AppColors.text.opacity(0.35))
                )
                .font(AppFonts.body)
                .foregroundColor(AppColors.text)
                .keyboardType(placeholder.lowercased().contains("correo") ? .emailAddress : .default)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .submitLabel(submitLabel)
                .onSubmit(onSubmit)
                .focused($isFocused)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, 15)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                .stroke(isFocused ? AppColors.primary : AppColors.text.opacity(0.12),
                        lineWidth: isFocused ? 1.5 : 1)
        )
        .appShadow(isFocused ? AppShadow.soft : AppShadowStyle(color: .clear, radius: 0, x: 0, y: 0))
        .animation(.easeInOut(duration: 0.18), value: isFocused)
    }
}

// MARK: - Primary Button

struct PrimaryButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.lg)
                .background(AppColors.primary)
                .clipShape(Capsule())
                .appShadow(AppShadow.soft)
        }
        .buttonStyle(.pressable)
    }
}

// MARK: - Divider

struct SocialDivider: View {
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Rectangle().fill(AppColors.text.opacity(0.12)).frame(height: 1)
            Text("o continúa con")
                .font(AppFonts.caption)
                .foregroundColor(AppColors.muted)
                .fixedSize()
            Rectangle().fill(AppColors.text.opacity(0.12)).frame(height: 1)
        }
    }
}

// MARK: - Social Buttons

struct SocialButtons: View {
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            // Native Apple Sign In
            SignInWithAppleButton(.signIn,
                onRequest: { _ in },
                onCompletion: { _ in }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))

            // Google (sin SDK nativo, usando botón estilizado)
            Button {} label: {
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: "g.circle.fill")
                        .font(.system(size: 19, weight: .medium))
                    Text("Continuar con Google")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(AppColors.text)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .stroke(AppColors.text.opacity(0.14), lineWidth: 1)
                )
            }
            .buttonStyle(.pressable)
        }
    }
}

// MARK: - Keyboard dismiss helper

extension UIApplication {
    static func hideKeyboard() {
        shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
