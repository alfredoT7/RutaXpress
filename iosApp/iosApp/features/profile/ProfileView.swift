import SwiftUI

private struct SettingRow: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let destructive: Bool
}

private let settingRows: [SettingRow] = [
    SettingRow(icon: "mappin.and.ellipse",  title: "Mis rutas",      destructive: false),
    SettingRow(icon: "bell",                title: "Notificaciones", destructive: false),
    SettingRow(icon: "questionmark.circle", title: "Ayuda",          destructive: false),
    SettingRow(icon: "rectangle.portrait.and.arrow.right", title: "Cerrar sesión", destructive: true),
]

struct ProfileView: View {
    var body: some View {
        ZStack(alignment: .top) {
            AppColors.bg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    profileHeader
                    settingsList
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.xl)
                .padding(.bottom, tabBarHeight + AppSpacing.lg)
            }
        }
        .navigationBarHidden(true)
    }

    private var profileHeader: some View {
        VStack(spacing: AppSpacing.sm) {
            Icons.user(color: AppColors.primary)
                .font(.system(size: 30, weight: .semibold))
                .frame(width: 76, height: 76)
                .background(AppColors.primarySoft)
                .clipShape(Circle())

            Text("Alfredo Torrico")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.text)

            Text("123456alfredotorri@gmail.com")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.muted)
        }
        .frame(maxWidth: .infinity)
    }

    private var settingsList: some View {
        VStack(spacing: AppSpacing.sm) {
            ForEach(settingRows) { row in
                Button(action: {}) {
                    HStack(spacing: AppSpacing.md) {
                        Image(systemName: row.icon)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(row.destructive ? AppColors.error : AppColors.primary)
                            .frame(width: 32, height: 32)
                            .background(row.destructive ? AppColors.error.opacity(0.12) : AppColors.primarySoft)
                            .clipShape(Circle())

                        Text(row.title)
                            .font(AppFonts.body)
                            .foregroundColor(row.destructive ? AppColors.error : AppColors.text)

                        Spacer()

                        if !row.destructive {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(AppColors.muted)
                        }
                    }
                    .card(padding: AppSpacing.md, radius: AppRadius.md)
                }
                .buttonStyle(.pressable)
            }
        }
    }
}

#Preview { ProfileView() }
