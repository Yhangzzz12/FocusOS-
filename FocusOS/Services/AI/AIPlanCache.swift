import Foundation

final class AIPlanCache {
    private struct Entry {
        let items: [AIPlanItem]
        let timestamp: Date
    }
    
    private var storage: [String: Entry] = [:]
    private let ttl: TimeInterval
    
    init(ttl: TimeInterval = 300) {
        self.ttl = ttl
    }
    
    func get(for key: String) -> [AIPlanItem]? {
        guard let entry = storage[key] else { return nil }
        if Date().timeIntervalSince(entry.timestamp) <= ttl {
            return entry.items
        } else {
            storage.removeValue(forKey: key)
            return nil
        }
    }
    
    func set(_ items: [AIPlanItem], for key: String) {
        storage[key] = Entry(items: items, timestamp: Date())
    }
}
