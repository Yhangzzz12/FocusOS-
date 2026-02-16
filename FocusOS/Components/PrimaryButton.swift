import SwiftUI

struct PrimaryButton: View {
    let title: String
    let isPulsing: Bool
    let action: () -> Void

    init(_ title: String, isPulsing: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isPulsing = isPulsing
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.headline())
                .foregroundStyle(AppColors.textGold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.md)
        }
        .background(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(AppColors.backgroundPrimary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(AppColors.strokeGoldStrong, lineWidth: AppStroke.medium)
        )
        .shadow(color: AppColors.goldGlow, radius: 10, x: 0, y: 0)
        .scaleEffect(isPulsing ? 1.02 : 1.0)
        .animation(isPulsing ? Motion.pulse : .default, value: isPulsing)
        .buttonStyle(PressableButtonStyle())
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .brightness(configuration.isPressed ? 0.03 : 0)
            .animation(Motion.snappy, value: configuration.isPressed)
    }
}

#Preview {
    ZStack {
        AppColors.backgroundPrimary.ignoresSafeArea()
        PrimaryButton("Start Focus") { }
            .padding()
    }
    .preferredColorScheme(.dark)
}
