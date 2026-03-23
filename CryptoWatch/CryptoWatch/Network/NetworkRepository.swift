import Foundation

public enum NetworkError: Error {
    case invalidUrl, invalidStatusCode
}

final actor NetworkRepository {
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 300
        config.requestCachePolicy = .reloadRevalidatingCacheData
        config.urlCache = nil
        config.waitsForConnectivity = true

        return URLSession(configuration: config)
    }()

    public func get<T: Codable>(_ type: T.Type, resource: String) async throws -> (Int, T) {
        return try await request(resource: resource, method: .get)
    }

    public func post<T: Codable, B: Codable>(_ type: T.Type, resource: String, body: B) async throws
        -> (Int, T)
    {
        return try await request(T.self, resource: resource, method: .post, body: body)
    }

    public func sharedSessions() -> URLSession {
        session
    }

    private func request<T: Codable>(resource: String, method: Method) async throws -> (Int, T) {
        let request = try configureRequest(resource, method)
        let (code, data) = try await runRequest(for: request)
        return (code, try JSONDecoder().decode(T.self, from: data))
    }

    private func request<T: Codable, B: Codable>(
        _ type: T.Type, resource: String, method: Method, body: B
    ) async throws
        -> (Int, T)
    {
        var request = try configureRequest(resource, method)
        request.httpBody = try JSONEncoder().encode(body)
        let (statusCode, data) = try await runRequest(for: request)
        return (statusCode, try JSONDecoder().decode(T.self, from: data))
    }

    private func configureRequest(_ resource: String, _ method: Method) throws -> URLRequest {
        guard let url = URL(string: resource) else {
            throw NetworkError.invalidUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }

    private func runRequest(for request: URLRequest) async throws -> (
        (Int, Data)
    ) {
        let (data, response) = try await session.data(for: request)

        guard let htttpResponse = response as? HTTPURLResponse,
            (200...299).contains(htttpResponse.statusCode)
        else {
            throw NetworkError.invalidStatusCode
        }

        return (htttpResponse.statusCode, data)
    }
}

private struct SuccessDto: Codable {}
