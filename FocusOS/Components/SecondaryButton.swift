import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.headline())
                .foregroundStyle(AppColors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.md)
        }
        .background(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(AppColors.backgroundCardElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(AppColors.strokeLight, lineWidth: AppStroke.default)
        )
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    ZStack {
        AppColors.backgroundPrimary.ignoresSafeArea()
        SecondaryButton("End") { }
            .padding()
    }
    .preferredColorScheme(.dark)
}
