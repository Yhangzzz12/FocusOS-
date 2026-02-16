import Foundation

enum TaskPriority: String, CaseIterable, Identifiable {
    case high = "High"
    case medium = "Med"
    case low = "Low"

    var id: String { rawValue }
}

struct FocusTask: Identifiable, Hashable {
    let id: UUID
    var title: String
    var note: String
    var priority: TaskPriority
    var isDone: Bool
    var dueDate: Date

    static let mock: [FocusTask] = [
        FocusTask(id: UUID(), title: "Deep work: Vision deck", note: "Slide 3-8", priority: .high, isDone: false, dueDate: .now),
        FocusTask(id: UUID(), title: "Review metrics", note: "Weekly KPI", priority: .medium, isDone: false, dueDate: .now),
        FocusTask(id: UUID(), title: "Inbox zero", note: "15 mins", priority: .low, isDone: true, dueDate: .now)
    ]
}
