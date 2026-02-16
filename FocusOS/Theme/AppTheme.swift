import SwiftUI

// MARK: - Color Tokens

struct AppColors {
    // Backgrounds
    static let backgroundPrimary = Color(hex: "0B0D10")
    static let backgroundSecondary = Color(hex: "111318")
    static let backgroundCard = Color(hex: "16181D")
    static let backgroundCardElevated = Color(hex: "1C1E24")
    static let backgroundInput = Color(hex: "1A1C22")

    // Accent
    static let gold = Color(hex: "D6B46A")
    static let goldLight = Color(hex: "E8CFA0")
    static let goldDim = Color(hex: "D6B46A").opacity(0.3)
    static let goldGlow = Color(hex: "D6B46A").opacity(0.08)

    // Text
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "8E8E93")
    static let textTertiary = Color(hex: "636366")
    static let textGold = Color(hex: "D6B46A")

    // Strokes
    static let strokeDefault = Color.white.opacity(0.08)
    static let strokeLight = Color.white.opacity(0.12)
    static let strokeGold = Color(hex: "D6B46A").opacity(0.3)
    static let strokeGoldStrong = Color(hex: "D6B46A").opacity(0.5)

    // Priority
    static let priorityHigh = Color(hex: "E85D5D")
    static let priorityMedium = Color(hex: "D6B46A")
    static let priorityLow = Color(hex: "4A9B6E")

    // States
    static let success = Color(hex: "4A9B6E")
    static let error = Color(hex: "E85D5D")

    // Bar Chart
    static let barInactive = Color(hex: "2A2D35")
}

// MARK: - Spacing

struct AppSpacing {
    static let xxxs: CGFloat = 2
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 6
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
    static let huge: CGFloat = 40
    static let massive: CGFloat = 48
}

// MARK: - Corner Radius

struct AppRadius {
    static let xs: CGFloat = 6
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let full: CGFloat = 100
}

// MARK: - Stroke

struct AppStroke {
    static let thin: CGFloat = 0.5
    static let `default`: CGFloat = 0.8
    static let medium: CGFloat = 1.0
    static let thick: CGFloat = 1.5
}

// MARK: - Shadows

struct AppShadow {
    static let card = ShadowSpec(color: .black.opacity(0.25), radius: 10, x: 0, y: 4)
    static let subtle = ShadowSpec(color: .black.opacity(0.15), radius: 6, x: 0, y: 2)
    static let goldGlow = ShadowSpec(color: AppColors.gold.opacity(0.12), radius: 14, x: 0, y: 0)
}

struct ShadowSpec {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Typography Helpers

struct AppFont {
    static func title2() -> Font { .title2 }
    static func title3() -> Font { .title3 }
    static func headline() -> Font { .headline }
    static func body() -> Font { .body }
    static func caption() -> Font { .caption }

    static func timer() -> Font {
        .system(size: 64, weight: .thin, design: .rounded)
    }

    static func timerSmall() -> Font {
        .system(size: 48, weight: .light, design: .rounded)
    }

    static func statNumber() -> Font {
        .system(size: 32, weight: .semibold, design: .rounded)
    }

    static func statNumberLarge() -> Font {
        .system(size: 40, weight: .bold, design: .rounded)
    }
}

// MARK: - View Helpers

extension View {
    func applyShadow(_ spec: ShadowSpec) -> some View {
        shadow(color: spec.color, radius: spec.radius, x: spec.x, y: spec.y)
    }
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
