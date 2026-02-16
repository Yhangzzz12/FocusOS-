import SwiftUI

struct StatCard: View {
    let value: String
    let title: String

    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(value)
                    .font(AppFont.statNumber())
                    .foregroundStyle(AppColors.textGold)
                    .contentTransition(.numericText())
                Text(title)
                    .font(AppFont.caption())
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }
}

#Preview {
    ZStack {
        AppColors.backgroundPrimary.ignoresSafeArea()
        HStack {
            StatCard(value: "86", title: "Minutes")
            StatCard(value: "7", title: "Streak")
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
