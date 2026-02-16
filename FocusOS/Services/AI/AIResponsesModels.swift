import Foundation

// MARK: - Request Models

struct AIResponsesRequest: Encodable {
    let model: String
    let input: [AIInputMessage]
    let text: AITextConfig
    let max_output_tokens: Int
    let reasoning: AIReasoningConfig?
}

struct AIInputMessage: Encodable {
    let role: String
    let content: [AIInputContent]
    
    static func system(_ text: String) -> AIInputMessage {
        AIInputMessage(role: "system", content: [.text(text)])
    }
    
    static func user(_ text: String) -> AIInputMessage {
        AIInputMessage(role: "user", content: [.text(text)])
    }
}

struct AIInputContent: Encodable {
    let type: String
    let text: String
    
    static func text(_ value: String) -> AIInputContent {
        AIInputContent(type: "input_text", text: value)
    }
}

struct AITextConfig: Encodable {
    let format: AITextFormat
    
    static func jsonObject() -> AITextConfig {
        AITextConfig(format: AITextFormat(type: "json_object", name: nil, strict: nil, schema: nil))
    }
    
    static func jsonSchemaPlan() -> AITextConfig {
        AITextConfig(
            format: AITextFormat(
                type: "json_schema",
                name: "ai_plan_v1",
                strict: true,
                schema: PlanSchema()
            )
        )
    }
}

struct AITextFormat: Encodable {
    let type: String
    let name: String?
    let strict: Bool?
    let schema: PlanSchema?
}

struct PlanSchema: Encodable {
    let type: String = "object"
    let properties = PlanSchemaProperties()
    let required: [String] = ["plan_items"]
    let additionalProperties: Bool = false
}

struct PlanSchemaProperties: Encodable {
    let plan_items = PlanItemsSchema()
}

struct PlanItemsSchema: Encodable {
    let type: String = "array"
    let minItems: Int = 1
    let items = PlanItemSchema()
}

struct PlanItemSchema: Encodable {
    let type: String = "object"
    let properties = PlanItemProperties()
    let required: [String] = ["title", "minutes", "difficulty"]
    let additionalProperties: Bool = false
}

struct PlanItemProperties: Encodable {
    let title = StringSchema(minLength: 2, maxLength: 80)
    let minutes = IntSchema(minimum: 1, maximum: 600)
    let difficulty = EnumSchema(values: ["Easy", "Med", "Hard"])
}

struct StringSchema: Encodable {
    let type: String = "string"
    let minLength: Int
    let maxLength: Int
}

struct IntSchema: Encodable {
    let type: String = "integer"
    let minimum: Int
    let maximum: Int
}

struct EnumSchema: Encodable {
    let type: String = "string"
    let `enum`: [String]
    
    init(values: [String]) {
        self.enum = values
    }
}

struct AIReasoningConfig: Encodable {
    let effort: String
}

// MARK: - Response Models

struct AIResponsesResponse: Decodable {
    let output: [AIOutput]?
    let output_text: String?
    
    func extractPlanAndText() throws -> (plan: AIPlanResponse, text: String) {
        let decoder = JSONDecoder()
        if let outputText = output_text {
            let sanitized = sanitizeJSON(outputText)
            if let data = sanitized.data(using: .utf8),
               let parsed = try? decoder.decode(AIPlanResponse.self, from: data) {
                return (parsed, sanitized)
            }
        }
        
        if let output {
            for item in output {
                for content in item.content ?? [] {
                    if content.type == "output_json", let json = content.json {
                        if let data = try? JSONEncoder().encode(json),
                           let text = String(data: data, encoding: .utf8) {
                            return (json, text)
                        }
                        return (json, "")
                    }
                    if content.type == "output_text", let text = content.text {
                        let sanitized = sanitizeJSON(text)
                        if let data = sanitized.data(using: .utf8),
                           let parsed = try? decoder.decode(AIPlanResponse.self, from: data) {
                            return (parsed, sanitized)
                        }
                    }
                }
            }
        }
        
        throw AIServiceError.decodingFailed
    }
    
    private func sanitizeJSON(_ text: String) -> String {
        var trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("```") {
            trimmed = trimmed.replacingOccurrences(of: "```json", with: "")
            trimmed = trimmed.replacingOccurrences(of: "```", with: "")
            trimmed = trimmed.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return trimmed
    }
}

struct AIOutput: Decodable {
    let content: [AIContent]?
}

struct AIContent: Decodable {
    let type: String
    let text: String?
    let json: AIPlanResponse?
}

struct AIPlanResponse: Codable {
    let plan_items: [AIPlanItemResponse]
}

struct AIPlanItemResponse: Codable {
    let title: String
    let minutes: Int
    let difficulty: String
    let reason: String?
}

struct AIErrorEnvelope: Decodable {
    let error: AIError
}

struct AIError: Decodable {
    let message: String
}
