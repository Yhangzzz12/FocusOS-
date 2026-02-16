import Foundation

enum AILogger {
    static func log(_ type: AIProviderType, _ message: String) {
        print("[AIProvider][\(type.rawValue)] \(message)")
    }
    
    static func log(_ message: String) {
        print("[AIProvider] \(message)")
    }
}
