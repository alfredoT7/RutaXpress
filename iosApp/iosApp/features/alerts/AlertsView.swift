import SwiftUI

private struct AlertRow: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let time: String
    let unread: Bool
}

private let mockAlerts: [AlertRow] = [
    AlertRow(title: "Trufi cerca de tu parada", subtitle: "Línea 4 llega en 3 min a Cala Cala", time: "Ahora",     unread: true),
    AlertRow(title: "Ruta 4 con demora",        subtitle: "Congestión reportada en Av. Heroínas", time: "12 min", unread: true),
    AlertRow(title: "Trufi #07 lleno",          subtitle: "Espera el siguiente en tu parada",     time: "35 min", unread: false),
    AlertRow(title: "Nueva parada disponible",  subtitle: "Se agregó una parada en Recoleta",     time: "Ayer",   unread: false),
]

struct AlertsView: View {
    @State private var alerts = mockAlerts

    var body: some View {
        ZStack(alignment: .top) {
            AppColors.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    header

                    if alerts.isEmpty {
                        emptyState
                    } else {
                        VStack(spacing: AppSpacing.sm) {
                            ForEach(alerts) { alert in
                                row(alert)
                            }
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.sm)
                .padding(.bottom, tabBarHeight + AppSpacing.lg)
            }
        }
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack {
            Text("Alertas")
                .font(AppFonts.title)
                .foregroundColor(AppColors.text)
            Spacer()
            if alerts.contains(where: { $0.unread }) {
                Button(action: {
                    alerts = alerts.map { AlertRow(title: $0.title, subtitle: $0.subtitle, time: $0.time, unread: false) }
                }) {
                    Text("Marcar leídas")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                }
                .buttonStyle(.pressable)
            }
        }
    }

    private func row(_ alert: AlertRow) -> some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            Icons.bell(color: AppColors.primary)
                .font(.system(size: 15, weight: .semibold))
                .frame(width: 32, height: 32)
                .background(AppColors.primarySoft)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(alert.title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.text)
                Text(alert.subtitle)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.muted)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: AppSpacing.xs) {
                Text(alert.time)
                    .font(AppFonts.footnote)
                    .foregroundColor(AppColors.muted)
                if alert.unread {
                    Circle()
                        .fill(AppColors.error)
                        .frame(width: 8, height: 8)
                }
            }
        }
        .card(padding: AppSpacing.md, radius: AppRadius.md)
    }

    private var emptyState: some View {
        VStack(spacing: AppSpacing.sm) {
            Icons.bell(color: AppColors.muted)
                .font(.system(size: 28))
            Text("Sin alertas por ahora")
                .font(AppFonts.body)
                .foregroundColor(AppColors.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppSpacing.xxl)
    }
}

#Preview { AlertsView() }
