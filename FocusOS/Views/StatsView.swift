import SwiftUI

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()
    @State private var showContent = false
    @State private var animateIn = false
    
    private let jellySpring = Animation.interactiveSpring(response: 0.45, dampingFraction: 0.72, blendDuration: 0.15)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                if showContent {
                    BarChart(values: viewModel.weeklyMinutes, labels: viewModel.labels)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                if showContent {
                    HStack(spacing: AppSpacing.md) {
                        PremiumCard {
                            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                Text("Weekly Trend")
                                    .font(AppFont.headline())
                                Text(viewModel.trendText)
                                    .font(AppFont.caption())
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                        }
                        PremiumCard {
                            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                Text("Distraction")
                                    .font(AppFont.headline())
                                Text(viewModel.distractionText)
                                    .font(AppFont.caption())
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                if showContent {
                    PremiumCard {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Weakness")
                                .font(AppFont.headline())
                            Text(viewModel.weaknessTip)
                                .font(AppFont.body())
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(AppSpacing.xxl)
        }
        .background(AppColors.backgroundPrimary)
        .navigationTitle("Stats")
        .scaleEffect(animateIn ? 1.0 : 0.94)
        .opacity(animateIn ? 1.0 : 0.02)
        .blur(radius: animateIn ? 0 : 5)
        .animation(jellySpring, value: animateIn)
        .onAppear { triggerEntrance() }
        .onDisappear { resetEntrance() }
    }
    
    private func triggerEntrance() {
        animateIn = false
        showContent = false
        DispatchQueue.main.async {
            withAnimation(jellySpring) {
                animateIn = true
            }
            withAnimation(Motion.ease) {
                showContent = true
            }
        }
    }
    
    private func resetEntrance() {
        animateIn = false
        showContent = false
    }
}

#Preview {
    NavigationStack {
        StatsView()
    }
    .preferredColorScheme(.dark)
}
