import Foundation

enum OpenAIConfig {
    #if DEBUG
    private static var didLog = false
    #endif
    
    static var apiKey: String? {
        let resolved = resolveKey()
        debugLog(source: resolved.source, value: resolved.key ?? "")
        return resolved.key
    }
    
    #if DEBUG
    private static func debugLog(source: String, value: String) {
        guard !didLog else { return }
        didLog = true
        let isPlaceholder = value.contains("$(OPENAI_API_KEY)")
        let len = value.count
        let display = value.isEmpty ? "nil" : value
        print("Loaded OPENAI_API_KEY:", display)
        print("OpenAIConfig key source=\(source) len=\(len) placeholder=\(isPlaceholder)")
    }
    #endif
    
    static func startupLog() {
        #if DEBUG
        let resolved = resolveKey()
        print("Loaded OPENAI_API_KEY:", resolved.key ?? "nil")
        print("Key source:", resolved.source)
        print("Key length:", resolved.key?.count ?? 0)
        #endif
    }
    
    private static func resolveKey() -> (key: String?, source: String) {
        if let key = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] {
            let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty { return (trimmed, "env") }
        }
        if let info = Bundle.main.infoDictionary,
           let key = info["OPENAI_API_KEY"] as? String {
            let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty { return (trimmed, "plist") }
        }
        if let key = readFromBundledXcconfig() {
            let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty { return (trimmed, "bundle-xcconfig") }
        }
        return (nil, "missing")
    }
    
    private static func readFromBundledXcconfig() -> String? {
        guard let url = Bundle.main.url(forResource: "OpenAI", withExtension: "xcconfig"),
              let content = try? String(contentsOf: url) else { return nil }
        for line in content.split(separator: "\n") {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.hasPrefix("//") || trimmed.isEmpty { continue }
            if trimmed.hasPrefix("OPENAI_API_KEY") {
                let parts = trimmed.split(separator: "=", maxSplits: 1)
                if parts.count == 2 {
                    return parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
        return nil
    }
}
