import Foundation

enum AIDifficulty: String, CaseIterable, Identifiable {
    case easy = "Easy"
    case medium = "Med"
    case hard = "Hard"

    var id: String { rawValue }
}

struct AIPlanItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let minutes: Int
    let difficulty: AIDifficulty
    let reason: String

    static let mock: [AIPlanItem] = [
        AIPlanItem(id: UUID(), title: "Define top 3 outcomes", minutes: 15, difficulty: .easy, reason: "Clarify intent and reduce scope."),
        AIPlanItem(id: UUID(), title: "Deep work: 2 focus blocks", minutes: 60, difficulty: .hard, reason: "Longest uninterrupted work window."),
        AIPlanItem(id: UUID(), title: "Review + summarize", minutes: 20, difficulty: .medium, reason: "Lock in memory and next steps.")
    ]
}
