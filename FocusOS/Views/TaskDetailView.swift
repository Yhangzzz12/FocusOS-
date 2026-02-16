import SwiftUI

struct TaskDetailView: View {
    let task: FocusTask

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xxl) {
                PremiumCard {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text(task.title)
                            .font(AppFont.title3())
                        Text(task.note.isEmpty ? "No notes" : task.note)
                            .font(AppFont.body())
                            .foregroundStyle(AppColors.textSecondary)
                        HStack(spacing: AppSpacing.sm) {
                            TagPill(text: task.priority.rawValue)
                            Text(task.dueDate.formatted(date: .abbreviated, time: .omitted))
                                .font(AppFont.caption())
                                .foregroundStyle(AppColors.textTertiary)
                        }
                    }
                }

                PremiumCard {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Plan Suggestion")
                            .font(AppFont.headline())
                        Text("Start with a 15-min outline, then 2 x 25-min focus blocks.")
                            .font(AppFont.body())
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }

                PrimaryButton("Start Focus with this task") {
                    Haptics.medium()
                }
            }
            .padding(AppSpacing.xxl)
        }
        .background(AppColors.backgroundPrimary)
        .navigationTitle("Task Detail")
    }
}

#Preview {
    NavigationStack {
        TaskDetailView(task: FocusTask.mock[0])
    }
    .preferredColorScheme(.dark)
}
