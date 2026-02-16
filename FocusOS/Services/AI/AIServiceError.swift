import Foundation

enum AIServiceError: LocalizedError, Equatable {
    case missingAPIKey
    case offline
    case timeout
    case rateLimited(seconds: Int)
    case invalidResponse
    case decodingFailed
    case server(message: String)
    case network(message: String)
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Missing API key (OPENAI_API_KEY)。请配置。"
        case .offline:
            return "当前离线，无法生成计划。"
        case .timeout:
            return "请求超时，请稍后重试。"
        case .rateLimited(let seconds):
            return "操作过于频繁，请 \(seconds)s 后再试。"
        case .invalidResponse:
            return "响应无效，请稍后重试。"
        case .decodingFailed:
            return "JSON 解析失败，请稍后重试。"
        case .server(let message):
            return message.isEmpty ? "服务返回错误。" : message
        case .network(let message):
            return message.isEmpty ? "网络错误，请稍后重试。" : message
        }
    }
}
