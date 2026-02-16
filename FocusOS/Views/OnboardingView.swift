import SwiftUI

struct OnboardingView: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxl) {
            Spacer()

            Text("FocusOS turns discipline into a calm, repeatable system.")
                .font(AppFont.title2())
                .foregroundStyle(AppColors.textPrimary)

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Label("Tesla-grade minimal focus ritual", systemImage: "sparkles")
                    .labelStyle(BulletLabelStyle())
                Label("Clear metrics, clear intent", systemImage: "chart.line.uptrend.xyaxis")
                    .labelStyle(BulletLabelStyle())
            }
            .foregroundStyle(AppColors.textSecondary)

            PrimaryButton("Continue") {
                Haptics.light()
                onContinue()
            }

            Spacer()
        }
        .padding(AppSpacing.xxl)
        .background(AppColors.backgroundPrimary.ignoresSafeArea())
    }
}

private struct BulletLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: AppSpacing.sm) {
            configuration.icon
                .foregroundStyle(AppColors.textGold)
                .font(.caption)
            configuration.title
                .font(AppFont.body())
        }
    }
}

#Preview {
    OnboardingView { }
        .preferredColorScheme(.dark)
}
