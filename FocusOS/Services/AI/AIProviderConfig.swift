import Foundation

enum AIProviderConfig {
    static func currentProviderType() -> AIProviderType {
        if let env = ProcessInfo.processInfo.environment["AI_PROVIDER"], let type = AIProviderType(rawValue: env.lowercased()) {
            return type
        }
        if let info = Bundle.main.object(forInfoDictionaryKey: "AI_PROVIDER") as? String,
           let type = AIProviderType(rawValue: info.lowercased()) {
            return type
        }
        if let stored = UserDefaults.standard.string(forKey: "aiProviderType"),
           let type = AIProviderType(rawValue: stored.lowercased()) {
            return type
        }
        return .openai
    }
}
