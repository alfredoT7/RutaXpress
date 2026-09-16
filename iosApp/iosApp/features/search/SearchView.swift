import SwiftUI

private struct RouteRow: Identifiable {
    let id = UUID()
    let name: String
    let line: String
    let eta: String
    let recent: Bool
}

private let mockRoutes: [RouteRow] = [
    RouteRow(name: "Cala Cala – Centro",     line: "Línea 4",  eta: "6 min",  recent: true),
    RouteRow(name: "Quillacollo – Centro",   line: "Línea 12", eta: "14 min", recent: true),
    RouteRow(name: "Sacaba – Cancha",        line: "Línea 7",  eta: "10 min", recent: false),
    RouteRow(name: "Villa Coronilla – Norte", line: "Línea 1", eta: "9 min",  recent: false),
]

struct SearchView: View {
    @State private var query = ""

    private var recentRoutes: [RouteRow] { mockRoutes.filter { $0.recent } }
    private var allRoutes: [RouteRow] { mockRoutes.filter { !$0.recent } }

    var body: some View {
        ZStack(alignment: .top) {
            AppColors.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    header
                    searchBar

                    if !recentRoutes.isEmpty {
                        section(title: "Recientes", rows: recentRoutes)
                    }
                    section(title: "Todas las rutas", rows: allRoutes)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.sm)
                .padding(.bottom, tabBarHeight + AppSpacing.lg)
            }
        }
        .navigationBarHidden(true)
    }

    private var header: some View {
        Text("Buscar ruta")
            .font(AppFonts.title)
            .foregroundColor(AppColors.text)
    }

    private var searchBar: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(AppColors.muted)
            TextField("¿A dónde vas?", text: $query)
                .font(AppFonts.body)
                .foregroundColor(AppColors.text)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, 13)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.pill))
        .shadow(color: AppColors.text.opacity(0.07), radius: 8, x: 0, y: 2)
    }

    private func section(title: String, rows: [RouteRow]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.text)

            VStack(spacing: AppSpacing.sm) {
                ForEach(rows) { route in
                    Button(action: {}) {
                        HStack(spacing: AppSpacing.md) {
                            Image(systemName: "arrow.triangle.swap")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppColors.primary)
                                .frame(width: 32, height: 32)
                                .background(AppColors.primarySoft)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text(route.name)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.text)
                                Text(route.line)
                                    .font(AppFonts.callout)
                                    .foregroundColor(AppColors.muted)
                            }

                            Spacer()

                            Text(route.eta)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(AppColors.secondary)
                                .padding(.horizontal, AppSpacing.sm)
                                .padding(.vertical, 4)
                                .background(AppColors.secondary.opacity(0.15))
                                .clipShape(Capsule())
                        }
                        .card(padding: AppSpacing.md, radius: AppRadius.md)
                    }
                    .buttonStyle(.pressable)
                }
            }
        }
    }
}

#Preview { SearchView() }
