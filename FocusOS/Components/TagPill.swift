import SwiftUI

struct TagPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(AppFont.caption())
            .foregroundStyle(AppColors.textGold)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xxs)
            .background(
                Capsule()
                    .fill(AppColors.backgroundCardElevated)
            )
            .overlay(
                Capsule()
                    .stroke(AppColors.strokeGold, lineWidth: AppStroke.thin)
            )
    }
}

#Preview {
    ZStack {
        AppColors.backgroundPrimary.ignoresSafeArea()
        TagPill(text: "Hard")
    }
    .preferredColorScheme(.dark)
}
