import SwiftUI

// MARK: - Colores globales

enum AppColors {
    // Fondo
    static let bg         = Color(hex: "F2EDE3")
    static let surface    = Color(hex: "FFFFFF")
    static let surface2   = Color(hex: "EFE9DC")

    // Texto
    static let text       = Color(hex: "1C1C1C")
    static let muted      = Color(hex: "1C1C1C", opacity: 0.45)
    static let faint      = Color(hex: "1C1C1C", opacity: 0.10)
    static let line       = Color(hex: "1C1C1C", opacity: 0.08)

    // Marca
    static let primary    = Color(hex: "E8622A")   // naranja RutaX
    static let secondary  = Color(hex: "4BC9C4")   // cyan logo
    static let primarySoft = Color(hex: "E8622A", opacity: 0.12)

    // Estado
    static let ok         = Color(hex: "5C8A3C")
    static let warn       = Color(hex: "C7873B")
    static let error      = Color(hex: "D94F4F")
}

// MARK: - Tipografía global

enum AppFonts {
    static let largeTitle  = Font.system(size: 34, weight: .bold)
    static let title       = Font.system(size: 26, weight: .semibold)
    static let title2      = Font.system(size: 22, weight: .semibold)
    static let title3      = Font.system(size: 20, weight: .semibold)
    static let headline    = Font.system(size: 17, weight: .semibold)
    static let body        = Font.system(size: 15, weight: .regular)
    static let callout     = Font.system(size: 13, weight: .regular)
    static let caption     = Font.system(size: 12, weight: .regular)
    static let footnote    = Font.system(size: 11, weight: .regular)
}

// MARK: - Espaciado / Radio global

enum AppSpacing {
    static let xs: CGFloat  = 4
    static let sm: CGFloat  = 8
    static let md: CGFloat  = 12
    static let lg: CGFloat  = 16
    static let xl: CGFloat  = 24
    static let xxl: CGFloat = 32
}

enum AppRadius {
    static let sm: CGFloat   = 8
    static let md: CGFloat   = 12
    static let lg: CGFloat   = 16
    static let xl: CGFloat   = 24
    static let pill: CGFloat = 999
}

// MARK: - Sombras globales

struct AppShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

enum AppShadow {
    static let soft = AppShadowStyle(
        color: AppColors.text.opacity(0.06), radius: 10, x: 0, y: 4
    )
    static let card = AppShadowStyle(
        color: AppColors.text.opacity(0.08), radius: 16, x: 0, y: 6
    )
    static let floating = AppShadowStyle(
        color: AppColors.text.opacity(0.14), radius: 22, x: 0, y: 10
    )
}

extension View {
    func appShadow(_ style: AppShadowStyle) -> some View {
        shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
}

// MARK: - Card modifier

struct CardModifier: ViewModifier {
    var padding: CGFloat = AppSpacing.lg
    var radius: CGFloat = AppRadius.lg
    var stroke: Bool = true
    var shadow: AppShadowStyle = AppShadow.soft

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(stroke ? AppColors.line : Color.clear, lineWidth: 1)
            )
            .appShadow(shadow)
    }
}

extension View {
    func card(
        padding: CGFloat = AppSpacing.lg,
        radius: CGFloat = AppRadius.lg,
        stroke: Bool = true,
        shadow: AppShadowStyle = AppShadow.soft
    ) -> some View {
        modifier(CardModifier(padding: padding, radius: radius, stroke: stroke, shadow: shadow))
    }
}

// MARK: - Button style con tacto (press scale)

struct PressableButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.97

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    static var pressable: PressableButtonStyle { PressableButtonStyle() }
}

// MARK: - Hex helper

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a, r, g, b) = (255,        (int >> 8) * 17,    (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (a, r, g, b) = (255,        int >> 16,           int >> 8 & 0xFF,        int & 0xFF)
        case 8:  (a, r, g, b) = (int >> 24,  int >> 16 & 0xFF,    int >> 8 & 0xFF,        int & 0xFF)
        default: (a, r, g, b) = (255,        0,                   0,                      0)
        }
        _ = a
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: opacity
        )
    }
}
