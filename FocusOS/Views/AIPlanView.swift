import SwiftUI

struct AIPlanView: View {
    @StateObject private var viewModel = AIPlanViewModel()
    @State private var showContent = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                if showContent {
                    inputSection
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                if showContent {
                    PrimaryButton(viewModel.isLoading ? "Generating..." : "Generate plan") {
                        Haptics.medium()
                        print("AIPlan tapped")
                        viewModel.generatePlan()
                    }
                    .disabled(viewModel.isLoading)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                if viewModel.isLoading {
                    skeletonSection
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    planSection
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(AppSpacing.xxl)
        }
        .background(AppColors.backgroundPrimary)
        .navigationTitle("AI Plan")
        .onAppear { withAnimation(Motion.ease) { showContent = true } }
    }

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("What do you want to accomplish today?")
                .font(AppFont.headline())
            TextField("Describe your focus goal", text: $viewModel.goalText, axis: .vertical)
                .lineLimit(3...6)
                .padding(AppSpacing.md)
                .background(RoundedRectangle(cornerRadius: AppRadius.md).fill(AppColors.backgroundInput))
                .overlay(RoundedRectangle(cornerRadius: AppRadius.md).stroke(AppColors.strokeDefault, lineWidth: AppStroke.default))

            Text("Available time (minutes)")
                .font(AppFont.caption())
                .foregroundStyle(AppColors.textSecondary)
            TextField("90", text: $viewModel.minutesText)
                .keyboardType(.numberPad)
                .padding(AppSpacing.md)
                .background(RoundedRectangle(cornerRadius: AppRadius.md).fill(AppColors.backgroundInput))
                .overlay(RoundedRectangle(cornerRadius: AppRadius.md).stroke(AppColors.strokeDefault, lineWidth: AppStroke.default))
        }
    }

    private var skeletonSection: some View {
        VStack(spacing: AppSpacing.md) {
            ShimmerSkeleton(height: 80)
            ShimmerSkeleton(height: 80)
            ShimmerSkeleton(height: 80)
        }
        .allowsHitTesting(false)
    }

    private var planSection: some View {
        VStack(spacing: AppSpacing.md) {
            if viewModel.isCoolingDown && viewModel.cooldownSeconds > 0 {
                Text("Please wait \(viewModel.cooldownSeconds)s")
                    .font(AppFont.caption())
                    .foregroundStyle(AppColors.textTertiary)
            }
            if let message = viewModel.errorMessage {
                PremiumCard {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text(message)
                            .font(AppFont.body())
                            .foregroundStyle(AppColors.textSecondary)
                        if viewModel.isOffline {
                            TagPill(text: "Offline")
                        }
                        if viewModel.canRetry {
                            SecondaryButton("Retry") {
                                Haptics.light()
                                viewModel.retry()
                            }
                        }
                    }
                }
            }
            
            ForEach(viewModel.planItems) { item in
                PremiumCard {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        HStack {
                            Text(item.title)
                                .font(AppFont.headline())
                            Spacer()
                            TagPill(text: item.difficulty.rawValue)
                        }
                        Text("\(item.minutes) mins")
                            .font(AppFont.caption())
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AIPlanView()
    }
    .preferredColorScheme(.dark)
}
