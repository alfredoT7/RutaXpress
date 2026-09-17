import SwiftUI

private struct OnboardingPage {
    let icon: String
    let iconColor: Color
    let ringColor: Color
    let title: String
    let subtitle: String
}

private let pages: [OnboardingPage] = [
    OnboardingPage(
        icon: "location.fill",
        iconColor: AppColors.secondary,
        ringColor: AppColors.secondary,
        title: "Encuentra trufis en\ntiempo real",
        subtitle: "Visualiza la ubicación exacta de cada trufi en el mapa, en vivo."
    ),
    OnboardingPage(
        icon: "point.topleft.down.curvedto.point.bottomright.up",
        iconColor: AppColors.secondary,
        ringColor: AppColors.text.opacity(0.15),
        title: "Mira rutas y paradas\ncercanas",
        subtitle: "Consulta líneas, paradas y tiempos estimados antes de salir de casa."
    ),
    OnboardingPage(
        icon: "bell.fill",
        iconColor: AppColors.primary,
        ringColor: AppColors.primary.opacity(0.3),
        title: "Recibe alertas\ninteligentes",
        subtitle: "Te avisamos cuando tu trufi está cerca, para que salgas justo a tiempo."
    )
]

struct OnboardingView: View {
    let onFinish: () -> Void
    @State private var currentPage = 0

    var body: some View {
        ZStack {
            AppColors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Omitir") { onFinish() }
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.muted)
                        .padding(.trailing, AppSpacing.lg)
                        .padding(.top, AppSpacing.sm)
                }

                TabView(selection: $currentPage) {
                    ForEach(pages.indices, id: \.self) { i in
                        OnboardingPageView(page: pages[i])
                            .tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                HStack(spacing: 7) {
                    ForEach(pages.indices, id: \.self) { i in
                        Capsule()
                            .fill(i == currentPage ? AppColors.primary : AppColors.muted.opacity(0.3))
                            .frame(width: i == currentPage ? 20 : 7, height: 7)
                            .animation(.easeInOut(duration: 0.25), value: currentPage)
                    }
                }
                .padding(.bottom, AppSpacing.xl)

                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else {
                        onFinish()
                    }
                } label: {
                    HStack(spacing: AppSpacing.sm) {
                        Text(currentPage < pages.count - 1 ? "Siguiente" : "Comenzar")
                            .font(.system(size: 16, weight: .bold))
                        if currentPage < pages.count - 1 {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.lg)
                    .background(AppColors.primary)
                    .clipShape(Capsule())
                    .appShadow(AppShadow.soft)
                }
                .buttonStyle(.pressable)
                .padding(.horizontal, AppSpacing.xl)
                .padding(.bottom, AppSpacing.xxl)
            }
        }
    }
}

private struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var appeared = false

    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()

            ZStack {
                Circle()
                    .stroke(page.ringColor, lineWidth: 1.5)
                    .frame(width: 200, height: 200)
                    .scaleEffect(appeared ? 1.08 : 1.0)
                    .opacity(appeared ? 1.0 : 0.5)
                    .animation(
                        .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                        value: appeared
                    )

                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .fill(AppColors.surface)
                    .frame(width: 110, height: 110)
                    .shadow(color: AppColors.text.opacity(0.08), radius: 16, x: 0, y: 4)
                    .overlay(
                        Image(systemName: page.icon)
                            .font(.system(size: 40))
                            .foregroundColor(page.iconColor)
                    )
                    .scaleEffect(appeared ? 1.0 : 0.7)
                    .opacity(appeared ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.4), value: appeared)
            }

            VStack(spacing: AppSpacing.md) {
                Text(page.title)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(AppColors.text)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.muted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xxl)
            }
            .offset(y: appeared ? 0 : 20)
            .opacity(appeared ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.4).delay(0.15), value: appeared)

            Spacer()
        }
        .onAppear { appeared = true }
        .onDisappear { appeared = false }
    }
}

#Preview {
    OnboardingView(onFinish: {})
}
