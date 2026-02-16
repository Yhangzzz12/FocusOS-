import SwiftUI

struct TaskRow: View {
    let task: FocusTask

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            RoundedRectangle(cornerRadius: AppRadius.xs)
                .fill(task.priority.color)
                .frame(width: 4)

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(task.title)
                    .font(AppFont.body())
                    .foregroundStyle(AppColors.textPrimary)
                    .strikethrough(task.isDone, color: AppColors.textTertiary)
                if !task.note.isEmpty {
                    Text(task.note)
                        .font(AppFont.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            Spacer()
            if task.isDone {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(AppColors.backgroundCardElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .stroke(AppColors.strokeDefault, lineWidth: AppStroke.default)
        )
    }
}

private extension TaskPriority {
    var color: Color {
        switch self {
        case .high: return AppColors.priorityHigh
        case .medium: return AppColors.priorityMedium
        case .low: return AppColors.priorityLow
        }
    }
}

#Preview {
    ZStack {
        AppColors.backgroundPrimary.ignoresSafeArea()
        VStack(spacing: AppSpacing.md) {
            TaskRow(task: FocusTask.mock[0])
            TaskRow(task: FocusTask.mock[2])
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
