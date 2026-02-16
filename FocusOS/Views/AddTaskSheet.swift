import SwiftUI

struct AddTaskSheet: View {
    let onSave: (_ title: String, _ note: String, _ priority: TaskPriority, _ dueDate: Date) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var note = ""
    @State private var priority: TaskPriority = .medium
    @State private var dateOption: DateOption = .today
    @State private var customDate = Date()

    enum DateOption: String, CaseIterable, Identifiable {
        case today = "Today"
        case tomorrow = "Tomorrow"
        case custom = "Custom"
        var id: String { rawValue }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    inputSection
                    prioritySection
                    dateSection

                    PrimaryButton("Save") {
                        Haptics.medium()
                        onSave(title, note, priority, resolvedDate)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(AppSpacing.xxl)
            }
            .background(AppColors.backgroundPrimary)
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Title")
                .font(AppFont.caption())
                .foregroundStyle(AppColors.textSecondary)
            TextField("Task title", text: $title)
                .padding(AppSpacing.md)
                .background(RoundedRectangle(cornerRadius: AppRadius.md).fill(AppColors.backgroundInput))
                .overlay(RoundedRectangle(cornerRadius: AppRadius.md).stroke(AppColors.strokeDefault, lineWidth: AppStroke.default))

            Text("Note")
                .font(AppFont.caption())
                .foregroundStyle(AppColors.textSecondary)
            TextField("Optional note", text: $note, axis: .vertical)
                .lineLimit(3...5)
                .padding(AppSpacing.md)
                .background(RoundedRectangle(cornerRadius: AppRadius.md).fill(AppColors.backgroundInput))
                .overlay(RoundedRectangle(cornerRadius: AppRadius.md).stroke(AppColors.strokeDefault, lineWidth: AppStroke.default))
        }
    }

    private var prioritySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Priority")
                .font(AppFont.caption())
                .foregroundStyle(AppColors.textSecondary)
            Picker("Priority", selection: $priority) {
                ForEach(TaskPriority.allCases) { priority in
                    Text(priority.rawValue).tag(priority)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var dateSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Due Date")
                .font(AppFont.caption())
                .foregroundStyle(AppColors.textSecondary)
            Picker("Date", selection: $dateOption) {
                ForEach(DateOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)

            if dateOption == .custom {
                DatePicker("Custom date", selection: $customDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
        }
    }

    private var resolvedDate: Date {
        switch dateOption {
        case .today:
            return Date()
        case .tomorrow:
            return Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        case .custom:
            return customDate
        }
    }
}

#Preview {
    AddTaskSheet { _, _, _, _ in }
        .preferredColorScheme(.dark)
}
