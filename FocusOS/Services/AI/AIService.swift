import Foundation

protocol AIProvider {
    var type: AIProviderType { get }
    func generatePlan(goal: String, minutes: Int, model: String) async throws -> AIPlanResult
    func coachInsights(context: String) async throws -> String
    func predictScore(metrics: [String: Double]) async throws -> Double
    func scheduleDay(tasks: [FocusTask]) async throws -> [FocusTask]
    func analyzeWeakness(summary: String) async throws -> String
}

struct AIPlanResult {
    let items: [AIPlanItem]
    let rawResponse: String
}

extension AIProvider {
    func coachInsights(context: String) async throws -> String {
        AILogger.log(type, "coachInsights not implemented")
        throw AIServiceError.server(message: "Not implemented")
    }
    
    func predictScore(metrics: [String: Double]) async throws -> Double {
        AILogger.log(type, "predictScore not implemented")
        throw AIServiceError.server(message: "Not implemented")
    }
    
    func scheduleDay(tasks: [FocusTask]) async throws -> [FocusTask] {
        AILogger.log(type, "scheduleDay not implemented")
        throw AIServiceError.server(message: "Not implemented")
    }
    
    func analyzeWeakness(summary: String) async throws -> String {
        AILogger.log(type, "analyzeWeakness not implemented")
        throw AIServiceError.server(message: "Not implemented")
    }
}

struct AIProviderFactory {
    static func make(mode: AIServiceMode, provider: AIProviderType) -> AIProvider {
        switch mode {
        case .mock:
            return MockAIProvider(type: provider)
        case .live:
            switch provider {
            case .openai:
                let key = OpenAIConfig.apiKey ?? ""
                return OpenAIProvider(apiKey: key)
            case .deepseek:
                let key = DeepSeekConfig.apiKey ?? ""
                return DeepSeekProvider(apiKey: key)
            }
        }
    }
}
