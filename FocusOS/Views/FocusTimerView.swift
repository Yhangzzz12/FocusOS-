import SwiftUI

struct FocusTimerView: View {
    @StateObject private var viewModel = FocusTimerViewModel()
    @State private var showContent = false

    var body: some View {
        VStack(spacing: AppSpacing.xxl) {
            if showContent {
                VStack(spacing: AppSpacing.sm) {
                    Text(viewModel.formattedTime)
                        .font(AppFont.timer())
                        .foregroundStyle(AppColors.textPrimary)
                        .contentTransition(.numericText())
                    Text(viewModel.taskTitle)
                        .font(AppFont.body())
                        .foregroundStyle(AppColors.textSecondary)
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            if showContent {
                ProgressRing(progress: viewModel.todayProgress, lineWidth: 12)
                    .frame(width: 180, height: 180)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            if showContent {
                VStack(spacing: AppSpacing.md) {
                    PrimaryButton(viewModel.isRunning ? "Pause" : "Start", isPulsing: viewModel.isRunning) {
                        Haptics.medium()
                        viewModel.toggle()
                    }
                    SecondaryButton("End") {
                        Haptics.medium()
                        viewModel.end()
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            if showContent {
                PremiumCard(isInteractive: true) {
                    HStack {
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text("White Noise")
                                .font(AppFont.headline())
                            Text("Open ambient sounds")
                                .font(AppFont.caption())
                                .foregroundStyle(AppColors.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "waveform")
                            .foregroundStyle(AppColors.textGold)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            Spacer()
        }
        .padding(AppSpacing.xxl)
        .background(AppColors.backgroundPrimary)
        .navigationTitle("Focus Timer")
        .onAppear { withAnimation(Motion.ease) { showContent = true } }
    }
}

#Preview {
    NavigationStack {
        FocusTimerView()
    }
    .preferredColorScheme(.dark)
}
