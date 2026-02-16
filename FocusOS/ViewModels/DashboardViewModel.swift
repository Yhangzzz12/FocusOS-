import Foundation

final class DashboardViewModel: ObservableObject {
    @Published var summary: StatsSummary = .mock
    @Published var tasks: [FocusTask] = FocusTask.mock
    @Published var focusMinutes: Int = 45

    var currentTask: FocusTask? {
        tasks.first { !$0.isDone }
    }
}
