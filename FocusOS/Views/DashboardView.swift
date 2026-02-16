import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showContent = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                header

                if showContent {
                    statsSection
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                if showContent {
                    quickStartSection
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                if showContent {
                    tasksSection
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(AppSpacing.xxl)
        }
        .background(AppColors.backgroundPrimary)
        .navigationTitle("Dashboard")
        .onAppear {
            withAnimation(Motion.ease) { showContent = true }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Today")
                .font(AppFont.title2())
                .foregroundStyle(AppColors.textPrimary)
            Text("Stay sharp, stay calm.")
                .font(AppFont.body())
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    private var statsSection: some View {
        HStack(spacing: AppSpacing.md) {
            StatCard(value: "\(viewModel.summary.todayMins)", title: "Minutes")
            StatCard(value: "\(viewModel.summary.streak)", title: "Streak")
            StatCard(value: "\(viewModel.summary.tasksDone)", title: "Tasks Done")
        }
    }

    private var quickStartSection: some View {
        PremiumCard(isInteractive: true) {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                HStack {
                    Text("Focus Quick Start")
                        .font(AppFont.title3())
                        .foregroundStyle(AppColors.textPrimary)
                    Spacer()
                    TagPill(text: "Now")
                }
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(viewModel.currentTask?.title ?? "Choose a task")
                        .font(AppFont.headline())
                    Text("Estimated \(viewModel.focusMinutes) mins")
                        .font(AppFont.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
                PrimaryButton("Start Focus") {
                    Haptics.light()
                }
            }
        }
    }

    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("Today Tasks")
                    .font(AppFont.title3())
                Spacer()
                NavigationLink("View all") {
                    TasksView()
                }
                .font(AppFont.caption())
                .foregroundStyle(AppColors.textGold)
            }

            ForEach(viewModel.tasks.prefix(3)) { task in
                NavigationLink {
                    TaskDetailView(task: task)
                } label: {
                    TaskRow(task: task)
                }
                .buttonStyle(.plain)
            }

            NavigationLink {
                AIPlanView()
            } label: {
                PremiumCard {
                    HStack {
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text("AI Plan")
                                .font(AppFont.headline())
                            Text("Generate today's focus path")
                                .font(AppFont.caption())
                                .foregroundStyle(AppColors.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "sparkles")
                            .foregroundStyle(AppColors.textGold)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
    .preferredColorScheme(.dark)
}
