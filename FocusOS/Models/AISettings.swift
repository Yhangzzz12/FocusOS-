import Foundation

enum OpenAIModel: String, CaseIterable, Identifiable {
    case gpt5Mini = "gpt-5-mini"
    case gpt5_2 = "gpt-5.2"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .gpt5Mini: return "gpt-5-mini"
        case .gpt5_2: return "gpt-5.2"
        }
    }
}

enum AIServiceMode: String, CaseIterable, Identifiable {
    case mock
    case live
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .mock: return "Mock"
        case .live: return "Live"
        }
    }
}

enum AIProviderType: String, CaseIterable, Identifiable {
    case openai
    case deepseek
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .openai: return "OpenAI"
        case .deepseek: return "DeepSeek"
        }
    }
}
