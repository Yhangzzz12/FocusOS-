import SwiftUI

struct ShimmerSkeleton: View {
    let height: CGFloat
    let cornerRadius: CGFloat

    @State private var isAnimating = false

    init(height: CGFloat, cornerRadius: CGFloat = AppRadius.md) {
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(AppColors.backgroundCardElevated)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.02),
                                Color.white.opacity(0.08),
                                Color.white.opacity(0.02)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: isAnimating ? 120 : -120)
                    .blendMode(.screen)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
            .frame(height: height)
            .clipped()
    }
}

#Preview {
    ZStack {
        AppColors.backgroundPrimary.ignoresSafeArea()
        VStack(spacing: AppSpacing.md) {
            ShimmerSkeleton(height: 16)
            ShimmerSkeleton(height: 80)
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
