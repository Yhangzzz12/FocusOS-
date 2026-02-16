import Foundation

struct StatsSummary: Hashable {
    let todayMins: Int
    let streak: Int
    let tasksDone: Int

    static let mock = StatsSummary(todayMins: 86, streak: 7, tasksDone: 5)
}
