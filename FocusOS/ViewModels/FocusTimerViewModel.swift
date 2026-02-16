import Foundation

final class FocusTimerViewModel: ObservableObject {
    @Published var isRunning = false
    @Published var remainingSeconds: Int = 25 * 60
    @Published var totalSeconds: Int = 25 * 60
    @Published var todayProgress: Double = 0.65
    @Published var taskTitle: String = "Deep work: Vision deck"

    private var timer: Timer?

    var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func toggle() {
        isRunning ? pause() : start()
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
            } else {
                self.pause()
            }
        }
    }

    func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func end() {
        pause()
        remainingSeconds = totalSeconds
    }
}
