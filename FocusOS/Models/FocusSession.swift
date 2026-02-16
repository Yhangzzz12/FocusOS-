import Foundation

struct FocusSession: Identifiable, Hashable {
    let id: UUID
    let mins: Int
    let date: Date

    static let mock: [FocusSession] = [
        FocusSession(id: UUID(), mins: 32, date: .now),
        FocusSession(id: UUID(), mins: 45, date: Calendar.current.date(byAdding: .day, value: -1, to: .now) ?? .now),
        FocusSession(id: UUID(), mins: 25, date: Calendar.current.date(byAdding: .day, value: -2, to: .now) ?? .now)
    ]
}
