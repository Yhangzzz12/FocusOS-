import Foundation

struct AIHTTPClient {
    let baseURL: URL
    let headers: [String: String]
    let timeout: TimeInterval
    let session: URLSession
    
    init(baseURL: URL, headers: [String: String], timeout: TimeInterval = 20, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.headers = headers
        self.timeout = timeout
        self.session = session
    }
    
    func post(path: String, body: Data) async throws -> (Data, HTTPURLResponse) {
        var request = URLRequest(url: baseURL.appendingPathComponent(path), timeoutInterval: timeout)
        request.httpMethod = "POST"
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = body
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw AIServiceError.invalidResponse
        }
        return (data, http)
    }
}
