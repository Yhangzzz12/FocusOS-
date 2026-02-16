import SwiftUI

struct PremiumCard<Content: View>: View {
    private let isInteractive: Bool
    private let action: (() -> Void)?
    private let content: Content
    @State private var isPressed = false

    init(isInteractive: Bool = false, action: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.isInteractive = isInteractive
        self.action = action
        self.content = content()
    }

    var body: some View {
        if isInteractive {
            base
                .contentShape(RoundedRectangle(cornerRadius: AppRadius.lg))
                .onTapGesture { action?() }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation(Motion.snappy) { isPressed = true }
                        }
                        .onEnded { _ in
                            withAnimation(Motion.snappy) { isPressed = false }
                        }
                )
        } else {
            base
        }
    }
    
    private var base: some View {
        content
            .padding(AppSpacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(AppColors.backgroundCard)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .stroke(AppColors.strokeDefault, lineWidth: AppStroke.default)
            )
            .applyShadow(AppShadow.subtle)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .brightness(isPressed ? 0.02 : 0)
    }
}

#Preview {
    ZStack {
        AppColors.backgroundPrimary.ignoresSafeArea()
        PremiumCard(isInteractive: true) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Premium Card")
                    .font(AppFont.title3())
                Text("Minimal, quiet, and premium.")
                    .font(AppFont.body())
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
