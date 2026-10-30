import SwiftUI
import shared

enum AppTab: Hashable {
    case home, search, alerts, admin, profile
}

let tabBarHeight: CGFloat = 64

struct MainTabView: View {
    let role: String?
    @State private var selected: AppTab = .home

    private var isAdmin: Bool { role == "ROLE_ADMIN" }

    var body: some View {
        TabView(selection: $selected) {
            HomeView()
                .tabItem { Label("Inicio", systemImage: "house.fill") }
                .tag(AppTab.home)

            SearchView()
                .tabItem { Label("Buscar", systemImage: "magnifyingglass") }
                .tag(AppTab.search)

            AlertsView()
                .tabItem { Label("Alertas", systemImage: "bell.fill") }
                .tag(AppTab.alerts)

            if isAdmin {
                LineAdminView()
                    .tabItem { Label("Admin", systemImage: "shield.fill") }
                    .tag(AppTab.admin)
            }

            ProfileView(onLogout: {})
                .tabItem { Label("Perfil", systemImage: "person.fill") }
                .tag(AppTab.profile)
        }
        .tint(AppColors.primary)
        .onChange(of: role) { newRole in
            if newRole != "ROLE_ADMIN" && selected == .admin {
                selected = .home
            }
        }
    }
}

#Preview { MainTabView(role: "ROLE_USER") }
