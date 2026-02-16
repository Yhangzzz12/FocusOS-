import SwiftUI

struct TasksView: View {
    @StateObject private var viewModel = TasksViewModel()
    @State private var showAddSheet = false

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Picker("Segment", selection: $viewModel.selectedSegment) {
                ForEach(TasksViewModel.TaskSegment.allCases) { segment in
                    Text(segment.rawValue).tag(segment)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, AppSpacing.xxl)
            .padding(.top, AppSpacing.md)

            List {
                ForEach(viewModel.tasks) { task in
                    NavigationLink {
                        TaskDetailView(task: task)
                    } label: {
                        TaskRow(task: task)
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, AppSpacing.xxs)
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            withAnimation(Motion.ease) {
                                viewModel.delete(task)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(AppColors.error)
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            withAnimation(Motion.ease) {
                                viewModel.toggleDone(task)
                            }
                        } label: {
                            Label("Done", systemImage: "checkmark")
                        }
                        .tint(AppColors.success)
                    }
                }
                .listRowBackground(AppColors.backgroundPrimary)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .background(AppColors.backgroundPrimary)
        .navigationTitle("Tasks")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColors.textGold)
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddTaskSheet { title, note, priority, dueDate in
                viewModel.addMockTask(title: title, note: note, priority: priority, dueDate: dueDate)
                Haptics.light()
            }
        }
    }
}

#Preview {
    NavigationStack {
        TasksView()
    }
    .preferredColorScheme(.dark)
}
