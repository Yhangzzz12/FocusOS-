import Foundation

struct DeepSeekProvider: AIProvider {
    let type: AIProviderType = .deepseek
    private let apiKey: String
    private let maxOutputTokens: Int
    private let client: AIHTTPClient
    
    init(apiKey: String, timeout: TimeInterval = 20, maxOutputTokens: Int = 400) {
        self.apiKey = apiKey
        self.maxOutputTokens = maxOutputTokens
        self.client = AIHTTPClient(
            baseURL: URL(string: "https://api.deepseek.com/v1")!,
            headers: [
                "Authorization": "Bearer \(apiKey)",
                "Content-Type": "application/json"
            ],
            timeout: timeout
        )
    }
    
    func generatePlan(goal: String, minutes: Int, model: String) async throws -> AIPlanResult {
        guard !apiKey.isEmpty else { throw AIServiceError.missingAPIKey }
        
        let requestBody = AIResponsesRequest(
            model: model,
            input: [
                .system("You are a focused planning assistant. Return a strict JSON object matching the schema. Provide 3-5 steps, concise titles, realistic minutes, and a short reason for each."),
                .user("Goal: \(goal)\nAvailable minutes: \(minutes)\nReturn only JSON.")
            ],
            text: AITextConfig.jsonSchemaPlan(),
            max_output_tokens: maxOutputTokens,
            reasoning: AIReasoningConfig(effort: "low")
        )
        
        do {
            let body = try JSONEncoder().encode(requestBody)
            let requestJson = String(data: body, encoding: .utf8) ?? "<non-utf8>"
            AILogger.log(type, "request json: \(requestJson)")
            let (data, http) = try await client.post(path: "responses", body: body)
            AILogger.log(type, "HTTP status \(http.statusCode)")
            let raw = String(data: data, encoding: .utf8) ?? "<non-utf8>"
            AILogger.log(type, "raw response: \(raw)")
            print("RAW RESPONSE =", raw)
            guard (200..<300).contains(http.statusCode) else {
                let message = (try? JSONDecoder().decode(AIErrorEnvelope.self, from: data).error.message) ?? "HTTP \(http.statusCode)"
                AILogger.log(type, "error message: \(message)")
                throw AIServiceError.server(message: message)
            }
            let jsonText = extractText(data)
            print("EXTRACTED JSON =", jsonText)
            AILogger.log(type, "jsonText: \(jsonText)")
            if jsonText.isEmpty {
                print("RAW RESPONSE =", raw)
            }
            let normalizedText = normalizeJsonText(jsonText)
            print("JSON TEXT (normalized) =", normalizedText)
            AILogger.log(type, "jsonText(normalized): \(normalizedText)")
            guard !normalizedText.isEmpty else {
                print("JSON decode error:", "empty extracted text")
                throw AIServiceError.decodingFailed
            }
            let plan: AIPlanResponse
            do {
                plan = try JSONDecoder().decode(AIPlanResponse.self, from: Data(normalizedText.utf8))
            } catch {
                if let fallback = parsePlanFromText(normalizedText) {
                    print("JSON decode fallback used")
                    plan = fallback
                } else {
                    print("JSON decode error:", error.localizedDescription)
                    print("JSON text =", normalizedText)
                    throw AIServiceError.decodingFailed
                }
            }
            AILogger.log(type, "parsed plan_items count: \(plan.plan_items.count)")
            let items = plan.plan_items.map { item in
                let minutes = max(1, item.minutes)
                return AIPlanItem(
                    id: UUID(),
                    title: item.title,
                    minutes: minutes,
                    difficulty: AIDifficulty.from(item.difficulty),
                    reason: item.reason ?? ""
                )
            }
            return AIPlanResult(items: items, rawResponse: raw)
        } catch let error as AIServiceError {
            throw error
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw AIServiceError.offline
            case .timedOut:
                throw AIServiceError.timeout
            default:
                throw AIServiceError.network(message: urlError.localizedDescription)
            }
        } catch {
            throw AIServiceError.network(message: error.localizedDescription)
        }
    }
    
    private func logSnippet(prefix: String, data: Data, error: Error) {
        let snippet = String(data: data, encoding: .utf8) ?? "<non-utf8>"
        let trimmed = snippet.count > 300 ? String(snippet.prefix(300)) + "…" : snippet
        AILogger.log(type, "\(prefix): \(error) | snippet: \(trimmed)")
    }
    
    private func extractText(_ data: Data) -> String {
        guard let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return ""
        }
        if let outputText = root["output_text"] as? String, !outputText.isEmpty {
            return outputText
        }
        let output = (root["output"] as? [[String: Any]])?.first
        let content = (output?["content"] as? [[String: Any]])?.first
        return content?["text"] as? String ?? ""
    }
    
    private func normalizeJsonText(_ text: String) -> String {
        var trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("```") {
            trimmed = trimmed.replacingOccurrences(of: "```json", with: "")
            trimmed = trimmed.replacingOccurrences(of: "```", with: "")
            trimmed = trimmed.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let start = trimmed.firstIndex(of: "{"),
           let end = trimmed.lastIndex(of: "}") {
            let slice = trimmed[start...end]
            return String(slice)
        }
        return trimmed
    }
    
    private func parsePlanFromText(_ text: String) -> AIPlanResponse? {
        guard let data = text.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        let itemsAny = (obj["plan_items"] as? [[String: Any]]) ?? (obj["planItems"] as? [[String: Any]]) ?? []
        var items: [AIPlanItemResponse] = []
        for item in itemsAny {
            let title = item["title"] as? String ?? ""
            let difficulty = item["difficulty"] as? String ?? "Med"
            let reason = item["reason"] as? String
            let minutes = parseMinutes(item)
            if !title.isEmpty && minutes > 0 {
                items.append(AIPlanItemResponse(title: title, minutes: minutes, difficulty: difficulty, reason: reason))
            }
        }
        return items.isEmpty ? nil : AIPlanResponse(plan_items: items)
    }
    
    private func parseMinutes(_ item: [String: Any]) -> Int {
        if let minutes = item["minutes"] as? Int { return minutes }
        if let minutes = item["minutes"] as? Double { return Int(minutes.rounded()) }
        if let minutes = item["minutes"] as? String, let value = Int(minutes) { return value }
        if let duration = item["duration"] as? Int { return duration }
        if let duration = item["duration"] as? Double { return Int(duration.rounded()) }
        if let duration = item["duration"] as? String, let value = Int(duration) { return value }
        return 0
    }
}

private extension AIDifficulty {
    static func from(_ value: String) -> AIDifficulty {
        switch value.lowercased() {
        case "easy": return .easy
        case "med", "medium": return .medium
        case "hard": return .hard
        default: return .medium
        }
    }
}
