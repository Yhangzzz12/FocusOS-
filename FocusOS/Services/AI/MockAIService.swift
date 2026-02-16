import Foundation

struct MockAIProvider: AIProvider {
    let type: AIProviderType
    
    init(type: AIProviderType = .openai) {
        self.type = type
    }
    
    func generatePlan(goal: String, minutes: Int, model: String) async throws -> AIPlanResult {
        AILogger.log(type, "mock generatePlan")
        return AIPlanResult(items: AIPlanItem.mock, rawResponse: "{ \"mock\": true }")
    }
    
    func coachInsights(context: String) async throws -> String {
        AILogger.log(type, "mock coachInsights")
        return "Mock insight: keep it minimal and consistent."
    }
    
    func predictScore(metrics: [String: Double]) async throws -> Double {
        AILogger.log(type, "mock predictScore")
        return 0.78
    }
    
    func scheduleDay(tasks: [FocusTask]) async throws -> [FocusTask] {
        AILogger.log(type, "mock scheduleDay")
        return tasks
    }
    
    func analyzeWeakness(summary: String) async throws -> String {
        AILogger.log(type, "mock analyzeWeakness")
        return "Mock weakness: afternoon slump."
    }
}
