import Foundation

final class StatsViewModel: ObservableObject {
    @Published var weeklyMinutes: [Double] = [35, 50, 40, 60, 20, 55, 45]
    @Published var labels: [String] = ["M", "T", "W", "T", "F", "S", "S"]
    @Published var trendText: String = "Upward momentum · +12%"
    @Published var distractionText: String = "Most distracted: 3-5 PM"
    @Published var weaknessTip: String = "Try a 10-min reset after lunch to avoid the 3 PM dip."
}
