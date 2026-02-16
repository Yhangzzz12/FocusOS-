import Foundation

final class AIPlanViewModel: ObservableObject {
    @Published var goalText: String = ""
    @Published var minutesText: String = "90"
    @Published var isLoading = false
    @Published var planItems: [AIPlanItem] = []
    @Published var errorMessage: String?
    @Published var isOffline = false
    @Published var canRetry = false
    @Published var isCoolingDown = false
    @Published var cooldownSeconds: Int = 0
    
    private let cache = AIPlanCache()
    private let cooldownInterval: TimeInterval = 6
    private var cooldownUntil: Date?
    private var lastRequest: (goal: String, minutes: Int)?
    private var currentTask: Task<Void, Never>?
    private var cooldownTimer: Timer?
    
    func generatePlan() {
        print("AIPlan generatePlan() called")
        print("AIPlan tapped")
        let trimmedGoal = goalText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedGoal.isEmpty else {
            setError(.invalidResponse)
            return
        }
        
        let minutes = normalizedMinutes()
        let mode = AIServiceMode(rawValue: UserDefaults.standard.string(forKey: "aiServiceMode") ?? "") ?? .mock
        let model = OpenAIModel(rawValue: UserDefaults.standard.string(forKey: "openaiModel") ?? "") ?? .gpt5Mini
        let providerType = AIProviderConfig.currentProviderType()
        let key = cacheKey(goal: trimmedGoal, minutes: minutes, mode: mode, model: model, provider: providerType)
        
        if let cached = cache.get(for: key) {
            print("AIPlan cache hit")
            planItems = cached
            errorMessage = nil
            isOffline = false
            canRetry = false
            return
        }
        
        if let until = cooldownUntil, Date() < until {
            updateCooldown()
            if cooldownSeconds > 0 {
                print("AIPlan cooldown active: \(cooldownSeconds)s")
                setError(.rateLimited(seconds: cooldownSeconds))
            }
            return
        }
        
        startCooldown()
        
        isLoading = true
        planItems = []
        errorMessage = nil
        isOffline = false
        canRetry = false
        lastRequest = (trimmedGoal, minutes)
        
        AILogger.log(providerType, "request mode=\(mode.displayName) model=\(model.displayName) endpoint=/responses")
        let provider = AIProviderFactory.make(mode: mode, provider: providerType)
        
        currentTask?.cancel()
        currentTask = Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await provider.generatePlan(goal: trimmedGoal, minutes: minutes, model: model.rawValue)
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    print("AIPlan raw response:", result.rawResponse)
                    print("AIPlan parsed plan_items count:", result.items.count)
                    self.cache.set(result.items, for: key)
                    self.planItems = result.items
                    self.isLoading = false
                    print("AIPlan success: plan_items=\(result.items.count)")
                }
            } catch {
                guard !Task.isCancelled else { return }
                let mapped = self.mapError(error)
                print("AIPlan error:", mapped.localizedDescription)
                await MainActor.run {
                    self.isLoading = false
                    self.setError(mapped)
                    self.canRetry = self.shouldAllowRetry(mapped)
                }
            }
        }
    }
    
    func retry() {
        guard let lastRequest else { return }
        goalText = lastRequest.goal
        minutesText = "\(lastRequest.minutes)"
        generatePlan()
    }
    
    private func normalizedMinutes() -> Int {
        let raw = Int(minutesText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 60
        return min(max(raw, 5), 240)
    }
    
    private func cacheKey(goal: String, minutes: Int, mode: AIServiceMode, model: OpenAIModel, provider: AIProviderType) -> String {
        let normalized = goal
            .lowercased()
            .split(whereSeparator: \.isWhitespace)
            .joined(separator: " ")
        return "\(provider.rawValue)|\(mode.rawValue)|\(model.rawValue)|\(normalized)|\(minutes)"
    }
    
    private func setError(_ error: AIServiceError) {
        errorMessage = error.errorDescription
        isOffline = (error == .offline)
    }
    
    private func mapError(_ error: Error) -> AIServiceError {
        if let serviceError = error as? AIServiceError {
            return serviceError
        }
        return .network(message: error.localizedDescription)
    }
    
    private func shouldAllowRetry(_ error: AIServiceError) -> Bool {
        switch error {
        case .missingAPIKey, .rateLimited:
            return false
        default:
            return true
        }
    }
    
    private func startCooldown() {
        cooldownUntil = Date().addingTimeInterval(cooldownInterval)
        isCoolingDown = true
        updateCooldown()
        cooldownTimer?.invalidate()
        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateCooldown()
        }
    }
    
    private func updateCooldown() {
        guard let until = cooldownUntil else { return }
        let remaining = Int(ceil(until.timeIntervalSinceNow))
        cooldownSeconds = max(0, remaining)
        if cooldownSeconds == 0 {
            isCoolingDown = false
            cooldownUntil = nil
            cooldownTimer?.invalidate()
            cooldownTimer = nil
        }
    }
}
