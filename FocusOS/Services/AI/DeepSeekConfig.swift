import Foundation

enum DeepSeekConfig {
    static var apiKey: String? {
        if let key = ProcessInfo.processInfo.environment["DEEPSEEK_API_KEY"], !key.isEmpty {
            return key
        }
        if let key = Bundle.main.object(forInfoDictionaryKey: "DEEPSEEK_API_KEY") as? String, !key.isEmpty {
            return key
        }
        return nil
    }
}
