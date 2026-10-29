import SwiftUI
import shared

enum AppTab: Int, CaseIterable {
    case home, search, alerts, admin, profile

    var icon: String {
        switch self {
        case .home:    return "house.fill"
        case .search:  return "magnifyingglass"
        case .alerts:  return "bell.fill"
        case .admin:   return "shield.fill"
        case .profile: return "person.fill"
        }
    }

    var title: String {
        switch self {
        case .home:    return "Inicio"
        case .search:  return "Buscar"
        case .alerts:  return "Alertas"
        case .admin:   return "Admin"
        case .profile: return "Perfil"
        }
    }
}

let tabBarHeight: CGFloat = 64

struct MainTabView: View {
    let onLogout: () -> Void
    @State private var selected: AppTab = .home
    @State private var isAdmin = false
    /// 0 = sheet colapsado (tab bar visible) · 1 = sheet expandido (tab bar oculto)
    @State private var sheetProgress: CGFloat = 0

    /// Sólo Home controla el ocultado; en otras tabs el bar siempre visible.
    private var hide: CGFloat { selected == .home ? sheetProgress : 0 }

    private var visibleTabs: [AppTab] {
        AppTab.allCases.filter { $0 != .admin || isAdmin }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Contenido a pantalla completa: tamaño ESTABLE (ocultar el bar no lo redimensiona)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Tab bar superpuesta: se desliza y desvanece sin afectar el layout del contenido
            FixedTabBar(selected: $selected, tabs: visibleTabs)
                .offset(y: (tabBarHeight + 40) * hide)
                .opacity(Double(1 - hide))
                .allowsHitTesting(hide < 0.5)
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            KoinHelperKt.observeCurrentRole { role in
                DispatchQueue.main.async {
                    isAdmin = (role == "ROLE_ADMIN")
                    if selected == .admin && !isAdmin { selected = .home }
                }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch selected {
        case .home:    HomeView(sheetProgress: $sheetProgress)
        case .search:  SearchView()
        case .alerts:  AlertsView()
        case .admin:   LineAdminView()
        case .profile: ProfileView(onLogout: onLogout)
        }
    }
}

// MARK: - Tab bar fija (no flotante), estilo nativo pulido

private struct FixedTabBar: View {
    @Binding var selected: AppTab
    let tabs: [AppTab]

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(AppColors.line)
                .frame(height: 1)

            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { tab in
                    item(tab)
                }
            }
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, AppSpacing.xs)
        }
        .background(AppColors.surface.ignoresSafeArea(edges: .bottom))
    }

    private func item(_ tab: AppTab) -> some View {
        let isSelected = selected == tab
        return Button {
            selected = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 21, weight: isSelected ? .semibold : .regular))
                Text(tab.title)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .medium))
            }
            .foregroundColor(isSelected ? AppColors.primary : AppColors.muted)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview { MainTabView(onLogout: {}) }
