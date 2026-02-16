import Foundation

final class TasksViewModel: ObservableObject {
    @Published var tasks: [FocusTask] = FocusTask.mock
    @Published var selectedSegment: TaskSegment = .today

    enum TaskSegment: String, CaseIterable, Identifiable {
        case today = "Today"
        case week = "Week"
        var id: String { rawValue }
    }

    func toggleDone(_ task: FocusTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isDone.toggle()
    }

    func delete(_ task: FocusTask) {
        tasks.removeAll { $0.id == task.id }
    }

    func addMockTask(title: String, note: String, priority: TaskPriority, dueDate: Date) {
        let new = FocusTask(id: UUID(), title: title, note: note, priority: priority, isDone: false, dueDate: dueDate)
        tasks.insert(new, at: 0)
    }
}
