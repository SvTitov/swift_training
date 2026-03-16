import Foundation
import os

let HOST = "http://jsonplaceholder.typicode.com/users"

actor NetworkRepository {
    var session: URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(30)
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        return URLSession(configuration: config)
    }
    
    public func fetch_users() async throws(RepositoryError) -> [UserDto] {
        guard let url = URL(string: HOST) else {
            throw RepositoryError.wrongUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw RepositoryError.invalidStatusCode(-1)
            }
            
            Logger.app.debug(">>> Status code \(statusCode)")
            
            guard (200...299).contains(statusCode) else {
                throw RepositoryError.invalidStatusCode(statusCode)
            }
           
            return try JSONDecoder().decode([UserDto].self, from: data)
        } catch {
            Logger.network.error("Error while fetching remote data: \(error.localizedDescription)")
            throw RepositoryError.networkIssue
        }
    }
}

extension NetworkRepository {
    public enum RepositoryError: Error {
        case networkIssue
        case wrongUrl
        case invalidStatusCode(Int)
    }
}
