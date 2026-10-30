import SwiftUI
import shared

struct LineAdminView: View {
    @StateObject private var wrapper = LineAdminViewModelWrapper()
    @State private var identifier = ""
    @State private var showError = false
    @State private var showSuccess = false

    var body: some View {
        ZStack(alignment: .top) {
            AppColors.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    header

                    if wrapper.uiState.isLoadingRoutes {
                        ProgressView().frame(maxWidth: .infinity).padding(.top, AppSpacing.xxl)
                    } else {
                        routesList

                        if wrapper.uiState.isRefreshingRoutes {
                            HStack(spacing: AppSpacing.sm) {
                                ProgressView().controlSize(.small)
                                Text("Actualizando rutas…")
                                    .font(AppFonts.caption)
                                    .foregroundColor(AppColors.muted)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }

                        if let refreshError = wrapper.uiState.routeRefreshError {
                            HStack(alignment: .center, spacing: AppSpacing.md) {
                                Text("No se pudo actualizar. Mostrando rutas guardadas.")
                                    .font(AppFonts.caption)
                                    .foregroundColor(AppColors.muted)
                                Spacer(minLength: AppSpacing.xs)
                                Button("Reintentar") {
                                    wrapper.clearRouteRefreshError()
                                    wrapper.loadRoutes(forceRefresh: true)
                                }
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.primary)
                            }
                            .padding(.vertical, AppSpacing.xs)
                            .accessibilityLabel(refreshError)
                        }

                        if let route = wrapper.uiState.selectedRoute {
                            assignmentCard(for: route)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.xl)
                .padding(.bottom, AppSpacing.xxl)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            wrapper.startObserving()
            wrapper.loadRoutes()
        }
        .onDisappear { wrapper.stopObserving() }
        .onChange(of: wrapper.uiState.error) { error in
            if error != nil { showError = true }
        }
        .onChange(of: wrapper.uiState.successMessage) { message in
            if message != nil { showSuccess = true }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { wrapper.clearError() }
        } message: {
            Text(wrapper.uiState.error ?? "")
        }
        .alert("Listo", isPresented: $showSuccess) {
            Button("OK") { wrapper.clearSuccess() }
        } message: {
            Text(wrapper.uiState.successMessage ?? "")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Encargados de línea")
                .font(AppFonts.title)
                .foregroundColor(AppColors.text)
            Text("Elegí una ruta y asigná qué cuenta la administra")
                .font(AppFonts.body)
                .foregroundColor(AppColors.muted)
        }
    }

    private var routesList: some View {
        LazyVStack(spacing: AppSpacing.sm) {
            ForEach(wrapper.uiState.routes, id: \.id) { route in
                Button {
                    identifier = ""
                    wrapper.selectRoute(route)
                } label: {
                    HStack(spacing: AppSpacing.md) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(route.name)
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.text)
                            Text(adminLabel(for: route))
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.muted)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(AppColors.muted)
                    }
                    .card(padding: AppSpacing.md, radius: AppRadius.md)
                }
                .buttonStyle(.pressable)
            }
        }
    }

    @ViewBuilder
    private func assignmentCard(for route: Route) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Ruta: \(route.name)")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.text)

            AuthField(
                icon: "at",
                placeholder: "Usuario o email de la cuenta",
                text: $identifier,
                submitLabel: .search,
                onSubmit: { wrapper.lookupUser(identifier: identifier) }
            )

            if wrapper.uiState.isLookingUpUser {
                ProgressView().frame(maxWidth: .infinity)
            } else {
                PrimaryButton(label: "Buscar cuenta") {
                    wrapper.lookupUser(identifier: identifier)
                }
            }

            if let user = wrapper.uiState.foundUser {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(user.name).font(AppFonts.body).foregroundColor(AppColors.text)
                    Text("\(user.username) · \(user.email)").font(AppFonts.caption).foregroundColor(AppColors.muted)
                    Text("Rol actual: \(user.role)").font(AppFonts.caption).foregroundColor(AppColors.muted)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(AppSpacing.md)
                .background(AppColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))

                if wrapper.uiState.isSubmitting {
                    ProgressView().frame(maxWidth: .infinity)
                } else {
                    PrimaryButton(label: "Asignar como encargado de línea") {
                        wrapper.assignAdmin()
                    }
                }
            }

            if route.adminUserId != nil {
                Button("Quitar encargado actual") {
                    wrapper.unassignAdmin()
                }
                .font(AppFonts.callout)
                .foregroundColor(AppColors.error)
            }
        }
        .padding(AppSpacing.lg)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }
}

private func adminLabel(for route: Route) -> String {
    guard let adminId = route.adminUserId else { return "Sin encargado asignado" }
    return "Admin asignado: ID \(adminId.int64Value)"
}

#Preview {
    LineAdminView()
}
