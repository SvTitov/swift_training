import os
import Foundation

protocol UserServiceProtocol {
    func fetch() async throws -> [ UserModel ]
}

class UserService {
    let repo: NetworkRepository
    
    init(repo: NetworkRepository) {
        self.repo = repo
    }
}

extension UserService: UserServiceProtocol {
    func fetch() async throws -> [UserModel] {
        do {
            let dtos =  try await repo.fetch_users()
            return dtos.map { UserModel.map(from: $0) }
        } catch {
            Logger.app.warning("Fetching users failed with error: \(error)")
            throw error
        }
    }
}
